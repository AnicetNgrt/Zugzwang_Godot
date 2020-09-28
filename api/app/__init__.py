from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate

from .db import db, app
from .routes import *
