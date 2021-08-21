from flask import Flask
from dotenv import load_dotenv


load_dotenv()  # take environment variables from .env.


app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"