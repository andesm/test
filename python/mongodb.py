import pymongo

client = pymongo.MongoClient('fx-mongo', 27017)
db = client.fx
co = db.rate

