from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import exc
import sqlite3
import os
from dotenv import load_dotenv
load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SQL_ALCHEMY_DATABASE_SECRET_KEY')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('SQL_ALCHEMY_DATABASE_URI')
db = SQLAlchemy(app)

from .models import *

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
