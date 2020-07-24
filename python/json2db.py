import pymongo
import json

with open('rmp.json', 'r') as file:
    rmp = json.load(file)

client = pymongo.MongoClient('localhost', 27017)
db = client.rmp
co = db.rmp

for song in rmp:
    rmp[song].update({'file': song})
    co.insert_one(rmp[song])
