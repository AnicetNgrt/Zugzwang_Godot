"""Flask config."""
from os import environ, path
# from dotenv import load_dotenv

# basedir = path.abspath(path.dirname(__file__))
# load_dotenv(path.join(basedir, '.env'))


class Config:
    SECRET_KEY = "qN1cn*cdC&tbtP!XVv;]Qox\"O}<]J\#d1b`SJO4aDStrN7%$lt#CT\{\}Z@2*er;-yW@sjnMY]6rKx>}8SUynmt{W3&sx4zC:lOD.<y\"n~[bg]7T1bGB:;~@*xb^2UL=jz{"
    SECRET_USER_MANAGEMENT_KEY = "evVk>2rZQw~84/8Ixr*@!YnI'5:*59l%A:<i8)qSo$RbIa@l4<_v!JhzMktK)9:Ls2BT+tL6PNXVw?Zw!:me>Uk93s'G<:X;MObCH;gUGeB_&Op8WLcg4~BKqtlc9f[V"
    SECRET_GAME_MANAGEMENT_KEY = "y4z)v*CJxQ`FJ_}$C{FQR]AuGlu#-TtPP5lH7cCZH&:DSy_ttbA|OvB]b5_vD8K#BlaOV|gWwDGtoH=7rp)RW%QYv.WteYGm]TphOe8&YRY7-3`&c<o]N|@ZLISRJb$j"
    # SESSION_COOKIE_NAME = os.environ.get('SESSION_COOKIE_NAME')
    # STATIC_FOLDER = 'static'
    # TEMPLATES_FOLDER = 'templates'


class ProdConfig(Config):
    FLASK_ENV = 'production'
    DEBUG = False
    TESTING = False
    SQLALCHEMY_DATABASE_URI = "sqlite:///zugzwang.db" # environ.get('PROD_SQLALCHEMY_DATABASE_URI')


class DevConfig(Config):
    FLASK_ENV = 'development'
    DEBUG = True
    TESTING = True
    SQLALCHEMY_DATABASE_URI = "sqlite:///zugzwang.db" # environ.get('DEV_SQLALCHEMY_DATABASE_URI')