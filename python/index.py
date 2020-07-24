#!/usr/bin/python3
import cgitb
import pymongo
import json
import sys
import io, os

#cgitb.enable()

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stdin = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
print("Content-Type: application/json; charset=utf-8")
print()

client = pymongo.MongoClient('localhost', 27017)
db = client.rmp
co = db.rmp

if os.environ['REQUEST_METHOD'] == 'POST':
    song_json = json.loads(sys.stdin.read(), 'utf-8')
    with open("/tmp/rmp.log", 'a', encoding = 'utf-8') as file:
        print(song_json ,file = file)
        co.update_one({"file": song_json['file']}, {"$set": song_json}, upsert = True)
else:
    list = {}
    list['music'] = []
    
    for data in co.find():
        id = str(data['_id'])
        del data['_id']
        data.update({'id': id})
        list['music'].append(data)
        
    db_update_song = {}
    while True:
        play_now = False
        for data in list['music']:
            if data['now'] == 0:
                play_now = True

        if not play_now:
            for data in list['music']:
                if 0 < data['now']:
                    data['now'] -= 1
                    db_update_song[data['file']] = data['now']
        else:
            break

    for song in db_update_song:
            co.update_one({"file": song}, {"$set": {"now": db_update_song[song]}})

    print(json.dumps(list ,ensure_ascii = False, indent = 2))
    
