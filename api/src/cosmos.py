import pymongo
import os


def get_client():
    uri = os.environ['COSMOS_CONNECTION_STRING']
    return pymongo.MongoClient(uri)
