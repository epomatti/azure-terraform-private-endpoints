import pymongo
import os


def get_client():
    uri = os.environ['COSMOS_PRIMARY_CONNECTION_STRING']
    return pymongo.MongoClient(uri)
