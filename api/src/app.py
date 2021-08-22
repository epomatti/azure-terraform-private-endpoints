from flask import Flask, request
from dotenv import load_dotenv


load_dotenv()  # take environment variables from .env.


app = Flask(__name__)


@app.route("/api/employee", methods=['POST'])
def create_employee():
    json = request.get_json()
    print(json)
    return json
