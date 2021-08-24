from flask import Flask, request
from dotenv import load_dotenv
import employee
from json_encoder import JSONEncoder

load_dotenv()


app = Flask(__name__)


@app.route("/api/employee/<string:id>", methods=['GET'])
def get_employee(id):
    result = employee.find_employee_by_id(id)
    return JSONEncoder().encode(result)


@app.route("/api/employee", methods=['POST'])
def create_employee():
    json = request.get_json()
    result = employee.insert_employee(json)
    return {"id": str(result.inserted_id)}
