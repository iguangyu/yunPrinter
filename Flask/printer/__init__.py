from flask import Flask
import os

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = os.path.abspath("upload")
app.config['MAX_CONTENT_LENGTH'] = 10 * 1024 * 1024

from .routes import apis