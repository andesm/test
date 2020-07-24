import pymongo

client = pymongo.MongoClient('192.168.1.61', 27017)
db = client.my_database
co = db.my_collection
co.insert_one({"test": 3})
for data in co.find():
    print(data)

