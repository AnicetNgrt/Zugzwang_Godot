from app import app, models, db
from .db import commit
from flask import g, make_response, abort, request, url_for
from flask.json import jsonify
from flask_httpauth import HTTPBasicAuth
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

auth = HTTPBasicAuth()
limiter = Limiter(
    app,
    key_func=get_remote_address,
    default_limits=["2400000000 per day", "60000 per hour"]
)

@app.route('/')
@app.route('/index')
@limiter.exempt
def index():
    return "Hello world"

@auth.verify_password
def verify_password(username_or_token, password):
    # first try to authenticate by token
    player = models.Player.verify_auth_token(username_or_token)
    if not player:
        # try to authenticate with username/password
        user = models.Player.query.filter_by(username = username_or_token).first()
        if not player or not player.verify_password(password):
            return False
    g.player = player
    return True

@auth.error_handler
def unauthorized():
    return make_response(jsonify({'error': 'Unauthorized access'}), 401)

@app.route('/api/v1.0/players', methods=['GET'])
def get_players():
    players = models.Player.query.all()
    respDict = {}
    for p in players:
        respDict[p.id] = { 'username': p.username }
    return jsonify(respDict), 201

@app.route('/api/v1.0/players/<int:player_id>', methods=['GET'])
def get_player(player_id:int):
    player = models.Player.query.filter_by(id = player_id).first()
    return jsonify({ 'username': player.username }), 201, {'Location': url_for('get_player', player_id = player.id, _external = True)}

@app.route('/api/v1.0/players', methods = ['POST'])
def new_player():
    if not request.json:
        abort(400)
    username = request.json.get('username')
    password = request.json.get('password')
    print(request.json);
    if username is None or password is None:
        return jsonify({ 'reason': 'EMPTY_MANDATORY' }), 400
    if models.Player.query.filter_by(username = username).first() is not None:
        return jsonify({ 'reason': 'USERNAME_TAKEN' }), 400
    player = models.Player(username = username)
    player.hash_password(password)
    db.session.add(player)
    commit(db.session)
    print(player.id)
    return jsonify({ 'username': player.username }), 201, {'Location': url_for('get_player', player_id = player.id, _external = True)}

@app.route('/api/v1.0/token')
@auth.login_required
def get_auth_token():
    token = g.player.generate_auth_token()
    return jsonify({ 'token': token.decode('ascii') })

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error':'Not found'}), 404)

@app.errorhandler(429)
def ratelimit_handler(e):
    return make_response(
        jsonify(error="ratelimit exceeded %s" % e.description)
        , 429
    )
