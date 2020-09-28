from passlib.apps import custom_app_context as pwd_context
from sqlalchemy import Column, DateTime, Integer, ForeignKey, String, Boolean, TypeDecorator
from sqlalchemy.orm import relationship
import datetime

# from sqlalchemy.ext.declarative import declarative_base
# from sqlalchemy.ext.hybrid import hybrid_property
from itsdangerous import (
    TimedJSONWebSignatureSerializer as Serializer,
    BadSignature,
    SignatureExpired,
)
from .db import db, app
from sqlalchemy.sql.schema import Table


ArchivedGamePlayer = Table(
    "ArchivedGamePlayers",
    db.metadata,
    Column("playerId", Integer, ForeignKey("Players.id")),
    Column("archivedGameId", Integer, ForeignKey("ArchivedGames.id")),
    Column("team", Integer),
    Column("ranking", Integer)
)


GamePlayer = Table(
    "GamePlayers",
    db.metadata,
    Column("playerId", Integer, ForeignKey("Players.id")),
    Column("gameId", Integer, ForeignKey("Games.id")),
    Column("team", Integer)
)


class ArchivedGame(db.Model):
    __tablename__ = "ArchivedGames"
    id = Column(Integer, primary_key=True)
    players = relationship("Player", secondary=ArchivedGamePlayer, backref="archivedGames")
    started = Column(DateTime, default=datetime.datetime.now())
    finished = Column(DateTime)
    winningTeamIndex = Column(Integer)


class Game(db.Model):
    __tablename__ = "Games"
    id = Column(Integer, primary_key=True)
    players = relationship("Player", secondary=GamePlayer, backref="games")
    isStarted = Column(Boolean, default=False)


class Player(db.Model):
    __tablename__ = "Players"
    id = Column(Integer, primary_key=True)
    username = Column(String(32), index=True, unique=True, nullable=False)
    password_hash = Column(String(128), nullable=False)
    icon = Column(Integer)

    def hash_password(self, password):
        self.password_hash = pwd_context.encrypt(password)

    def verify_password(self, password):
        return pwd_context.verify(password, self.password_hash)

    def generate_auth_token(self, expiration=600):
        s = Serializer(app.config["SECRET_KEY"], expires_in=expiration)
        return s.dumps({"id": self.id})

    @staticmethod
    def verify_auth_token(token):
        s = Serializer(app.config["SECRET_KEY"])
        try:
            data = s.loads(token)
        except SignatureExpired:
            return None  # valid token, but expired
        except BadSignature:
            return None  # invalid token
        player = Player.query.get(data["id"])
        return player
