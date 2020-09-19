from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import exc
import sqlite3

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////zugzwang.db'
db = SQLAlchemy(app)

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
