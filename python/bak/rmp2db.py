import pymongo

file_list = {}
song_list = {}

for line in open('rmp.csv', 'r'):
    now, skip, count, repeat, score, song = line[:-1].split(',')
    song_list[song] = {'now': int(now), 'skip': int(skip), 'count': int(count), 'repeat': int(repeat), 'score': int(score)}

for line in open('aac2rmp.txt', 'r'):
    song, file = line[:-1].split('\t')
    if song in song_list:
        song_list[song]['file'] = file
    
client = pymongo.MongoClient('localhost', 27017)
db = client.rmp
co = db.rmp

for song in song_list:
    if 'file' in song_list[song]:
        #print(song, song_list[song])
        co.insert_one(song_list[song])

for data in co.find():
    print(data)

      

    
    
