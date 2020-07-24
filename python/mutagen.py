from mutagen.mp4 import MP4
from mutagen.easyid3 import EasyID3
import os, sys, io, json
import re

track_re = re.compile(r'^\((\d+), (\d+)\)')

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.stdin = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')

song_path = {}
for root, _, files in os.walk("./music"):
    for file in files:
        if file.endswith(".m4a"):
            path = os.path.join(root, file)
            song_path[path[8:]] = path

tags = ('\xa9nam', '\xa9alb', '\xa9ART', '\xa9gen', 'trkn')

music = {}
music['music'] = []

for song in song_path:
    audio = MP4(song_path[song])
    for tag in tags:
        if tag not in audio:
            if tag == 'trkn':
                audio[tag] = [(0 ,0)]
            else:
                audio[tag] = ['none']
    song_url = song.replace(' ', '%20')
    genre_mi = audio['\xa9gen'][0].replace('/', ',')
    music['music'].append({'title': audio['\xa9nam'][0], 'album': audio['\xa9alb'][0], 'artist': audio['\xa9ART'][0], 'genre': genre_mi, 'source': song_url, 'image': 'album_art.jpg', 'trackNumber': audio['trkn'][0][0], 'totalTrackCount': audio['trkn'][0][1], 'duration': 0, 'site': 'http://kotetu.flg.jp/~andesm/music/'})

print(json.dumps(music ,ensure_ascii = False, indent = 2))
