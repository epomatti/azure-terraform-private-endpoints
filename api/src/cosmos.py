import pymongo

#BAZ = os.environ['COSMOS_PRIMARY_CONNECTION_STRING']


def build_uri():
    uri = "mongodb://cosmos28251:JibpPgBtXXLF4Hx5HkhhfVDmfrhRjlbnDcAXgRNX2IdSnuhn4JINlcb8sztYJNAU8XHKuVnzEDrzS3dwUPNsVQ==@cosmos28251.mongo.cosmos.azure.com:10255/?ssl=true&retrywrites=false&replicaSet=globaldb&maxIdleTimeMS=120000&appName=@cosmos28251@"
    #uri = "mongodb://{user}:{password}@{endpoint}:10255/?ssl=true&retrywrites=false&replicaSet=globaldb&maxIdleTimeMS=120000&appName=@{user}@"
    return uri


def get_client():
    return pymongo.MongoClient(build_uri())


client = get_client()
database = client.get_database("database")
print(database)
