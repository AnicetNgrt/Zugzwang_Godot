from .db import commit, db, app
from .models import Player, Game, GamePlayer
from flask import g, make_response, abort, request  # , url_for
from flask.json import jsonify
from flask_httpauth import HTTPBasicAuth
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

auth = HTTPBasicAuth()
limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["2400000000 per day", "60000 per hour"],
)
permissions_keys = {
    "MANAGE_USERS":app.config.get("SECRET_USER_MANAGEMENT_KEY"),
    "MANAGE_GAMES":app.config.get("SECRET_GAME_MANAGEMENT_KEY")
}


def has_permission(secret_key, permission):
    if not permissions_keys.get(permission): 
        return False
    return permissions_keys.get(permission) == secret_key


@app.route("/")
@app.route("/index")
@limiter.exempt
def index():
    return "Hello world"


@auth.verify_password
def verify_password(username_or_token, password):
    player = Player.verify_auth_token(username_or_token)
    if not player:
        player = Player.query.filter_by(username=username_or_token).first()
        if not player or not player.verify_password(password):
            return False
    g.player = player
    g.permissions = {
        "MANAGE_USERS": False,
        "MANAGE_GAMES": False
    }
    return True


@auth.error_handler
def unauthorized():
    return make_response(jsonify({"reason": "Unauthorized access"}), 401)


@app.route("/api/v1.0/players", methods=["GET"])
def get_players():
    players = Player.query.all()
    respDict = {}
    for p in players:
        respDict[p.id] = {"username": p.username}
    return jsonify(respDict), 200


@app.route("/api/v1.0/players/<int:player_id>", methods=["GET"])
def get_player(player_id: int):
    player = Player.query.filter_by(id=player_id).first()
    if not player:
        abort(404)
    return (
        jsonify({"id": player.id, "username": player.username, "icon": player.icon}),
        200,
    )


@app.route("/api/v1.0/players", methods=["POST"])
def new_player():
    if not request.json:
        abort(400)
    username = request.json.get("username")
    password = request.json.get("password")
    print(request.json)
    if username is None or password is None:
        return jsonify({"reason": "EMPTY_MANDATORY"}), 400
    if Player.query.filter_by(username=username).first() is not None:
        return jsonify({"reason": "USERNAME_TAKEN"}), 400
    player = Player(username=username)
    player.hash_password(password)
    db.session.add(player)
    commit(db.session)
    return jsonify({"id": player.id}), 201


@app.route("/api/v1.0/games/<int:game_id>", methods=["GET"])
@auth.login_required()
def get_game(game_id: int):
    game = Game.query.filter_by(id=game_id).first()
    if not game: 
        abort(404)
    return jsonify({"id": game.id, "players": game.players})


@app.route("/api/v1.0/games/<string:secret_access_key>", methods=["GET"])
def get_games(secret_access_key):
    if not has_permission(secret_access_key, "MANAGE_USERS"):
        abort(403)


@app.route("/api/v1.0/token")
@auth.login_required
def get_auth_token():
    token = g.player.generate_auth_token()
    return jsonify({"token": token.decode("ascii")})


@app.route("/api/v1.0/login")
@auth.login_required
def login():
    return "", 200


@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({"reason": "Not found"}), 404)


@app.errorhandler(429)
def ratelimit_handler(e):
    return make_response(
        jsonify({"reason": "Ratelimit exceeded %s" % e.description}), 429
    )
