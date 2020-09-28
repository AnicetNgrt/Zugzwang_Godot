from flask import Flask
from flask_sqlalchemy import SQLAlchemy
import sqlite3

app = Flask(__name__)
# app.config.from_object('config.ProdConfig')
app.config.from_object('config.DevConfig')

#app.config['SECRET_KEY'] = 'djzapdjapmxqxùqxùzgwvas697696KSUHuqiqugsiqg911297'
#app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///zugzwang.db'
db = SQLAlchemy(app)

from .models import *
from sqlalchemy import exc

def commit(session):
    try:
        session.commit()
    except AssertionError as err:
        session.rollback()
        Flask.abort(409, err)
    except (exc.IntegrityError, sqlite3.IntegrityError) as err:
        session.rollback()
        Flask.abort(409, err.orig)
    except Exception as err:
        session.rollback()
        Flask.abort(500, err)
