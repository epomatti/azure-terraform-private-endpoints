import pymongo
import os


def build_uri():
    uri = os.environ['COSMOS_PRIMARY_CONNECTION_STRING']
    return uri


def get_client():
    return pymongo.MongoClient(build_uri())


client = get_client()
database = client.get_database("database")
