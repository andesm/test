import os, sys, tty, termios, signal, select
import random, time
import requests, json
import math

class RmpRank:
    command_disp = {'b': 'repeat', 's': 'skip  ', 'n': '      '}

    def __init__(self, song, now, skip, count, repeat, score):
        self.song = song
        self.now = now
        self.skip = skip
        self.count = count
        self.repeat = repeat
        self.score = score       

    def play_now(self):
        if self.now == 0:
            return True
        else:
            return False
        
    def update_db(self):
        sd = {}
        sd[song] = rank[song]
        r = requests.post('http://kotetu.flg.jp/~andesm/index.py', data = json.dumps(sd ,ensure_ascii = False).encode("utf-8"), headers = {'content-type': 'application/json'})

    def print_header(self):
        print("- %s [sc: %d, sk: %d, co: %d, re: %d]" % (self.song, self.score, self.skip, self.count, self.repeat)
        


while True:
    song_list = list(song_path.keys())
    random.shuffle(song_list)
    for song in song_list:
        now_song = song_rank[song]
        if now_song == True:
            now_song.print_header()
            while True:
                pid = os.fork()
                if pid == 0:
              os.execl('/usr/bin/mplayer', 'mplayer', '-msglevel', 'all=-1', '-slave', '-ao', 'sdl', '--no-consolecontrols', song_path[song])

while True:
    song_list = list(song_path.keys())
    random.shuffle(song_list)
    for song in song_list:
        now_song = song_rank[song]
        if now_song == True:
            now_song.print_header()
            while True:
                pid = os.fork()
                if pid == 0:
                    os.execl('/usr/bin/mplayer', 'mplayer', '-msglevel', 'all=-1', '-slave', '-ao', 'sdl', '--no-consolecontrols', song_path[song])


while True:
    song_list = list(song_path.keys())
    random.shuffle(song_list)
    for song in song_list:
        now_song = song_rank[song]
        if now_song.play_now() == True:
            now_song.print_header()
            while True:
                pid = os.fork()
                if pid == 0:
                    os.execl('/usr/bin/mplayer', 'mplayer', '-msglevel', 'all=-1', '-slave', '-ao', 'sdl', '--no-consolecontrols', song_path[song])
                else:
                  while True:
                  command = getch()
                        if command == 's' or command == 'q' or command == 'b':
                            os.kill(pid, signal.SIGKILL)
                            os.waitpid(pid, 0)
