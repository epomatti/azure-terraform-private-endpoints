import cosmos


# TODO implement Mongo reusability
def find_employee(name):
    client = cosmos.get_client()
    database = client.get_database("database")
    employees = database.get_collection("employees")
    return employees.find(f"{{ name: {name} }}")

# TODO implement Mongo reusability


def insert_employee(name):
    client = cosmos.get_client()
    database = client.get_database("database")
    employees = database.get_collection("employees")
    return employees.insert_one(name)
