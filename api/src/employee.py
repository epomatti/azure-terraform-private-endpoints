import cosmos


def find_employee(name):
    # TODO implement Mongo reusability
    client = cosmos.get_client()
    database = client.get_database("database")
    employees = database.get_collection("employees")
    return employees.find(f"{{ name: {name} }}")


def insert_employee(name):
    # TODO implement Mongo reusability
    client = cosmos.get_client()
    database = client.get_database("database")
    employees = database.get_collection("employees")
    return employees.insert_one(name)
