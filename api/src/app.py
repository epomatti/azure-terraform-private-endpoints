from flask import Flask
from dotenv import load_dotenv
import os

load_dotenv()  # take environment variables from .env.
BAZ = os.environ['COSMOS_PRIMARY_CONNECTION_STRING']

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"