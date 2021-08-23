import cosmos


def get_collection():
    # TODO implement Mongo reusability
    client = cosmos.get_client()
    database = client.get_database("database")
    return database.get_collection("employees")


def find_employee(name):
    employees = get_collection()
    return employees.find(f"{{ name: {name} }}")


def insert_employee(name):
    employees = get_collection()
    return employees.insert_one(name)
