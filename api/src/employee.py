from bson.objectid import ObjectId
import cosmos


def get_collection():
    # TODO implement Mongo reusability
    client = cosmos.get_client()
    database = client.get_database("database")
    return database.get_collection("employees")


def find_employee_by_id(id):
    employees = get_collection()
    query = {
        "_id": ObjectId(id)
    }
    return employees.find_one(query)


def insert_employee(employee):
    employees = get_collection()
    return employees.insert_one(employee)
