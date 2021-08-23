from flask import Flask, request
from dotenv import load_dotenv
import employee

load_dotenv()


app = Flask(__name__)


@app.route("/api/employee", methods=['POST'])
def create_employee():
    json = request.get_json()
    # TODO
    result = employee.insert_employee("")
    return result.inserted_id
