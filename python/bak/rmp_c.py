import os, sys, tty, termios, signal, select
import random, time
import requests, json
import math
import curses

def update_db(rank, song):
    sd = {}
    sd[song] = rank[song]
    r = requests.post('http://kotetu.flg.jp/~andesm/index.py', data = json.dumps(sd ,ensure_ascii = False).encode("utf-8"), headers = {'content-type': 'application/json'})

stdscr = curses.initscr()
curses.noecho()
curses.cbreak()
curses.curs_set(False)
stdscr.keypad(True)
stdscr.nodelay(True)
stdscr.timeout(100)
    
rmp = {}

for root, dirs, files in os.walk("./music"):
    for file in files:
        if file.endswith(".m4a"):
            path = os.path.join(root, file)
            rmp[path[8:]] = path
          
r = requests.get('http://kotetu.flg.jp/~andesm/index.py')
rank = r.json()

all = next = count = 0
for song in rank:
    all += 1
    if rank[song]['now'] == 0:
        next += 1
    if count < rank[song]['count']:
        count= rank[song]['count']

str = "Next  : %4d" % next
stdscr.addstr(0, 0, str)
str = "Count : %4d" % count        
stdscr.addstr(1, 0, str)
str = "All   : %4d" % all        
stdscr.addstr(2, 0, str)
stdscr.refresh()

line = 3
while True:
    song_list = list(rmp.keys())
    random.shuffle(song_list)
    for song in song_list:
        if not song in rank:
            rank[song] = {'now': 0, 'skip': 0, 'count': 0, 'repeat': 0, 'score': 0}
        if rank[song]['now'] == 0:
            str = "- %s [sc: %d, sk: %d, co: %d, re: %d]\n" \
                  % (song, rank[song]['score'], rank[song]['skip'], rank[song]['count'], rank[song]['repeat'])
            stdscr.addstr(line, 0, str)
            stdscr.refresh()
            line +=1
            while True:
                pid = os.fork()
                if pid == 0:
                    os.execl('/usr/bin/mplayer', 'mplayer', '-msglevel', 'all=-1', '-slave', rmp[song])
                else:
                    while True:
                        command = stdscr.getch()
                        print(command)
                        if command == ord('s') or command == ord('q') or command == ord('b'):
                            os.kill(pid, signal.SIGKILL)
                            os.waitpid(pid, 0)
                            break
                        else:
                            zpid, status = os.waitpid(pid, os.WNOHANG)
                            if 0 < zpid:
                                command = ord('n')
                                break
                            
                    if command == ord('b'):
                        str = "    repeat [sc: %d, sk: %d, co: %d, re: %d] -> " \
                              % (rank[song]['score'], rank[song]['skip'], rank[song]['count'], rank[song]['repeat'])
                        rank[song]['repeat'] += 1
                        rank[song]['score'] = rank[song]['count'] + rank[song]['repeat'] - (rank[song]['now'] + rank[song]['skip'])
                    elif command == ord('s'):
                        str =  "    skip    [sc: %d, sk: %d, co: %d, re: %d] -> " \
                              % (rank[song]['score'], rank[song]['skip'], rank[song]['count'], rank[song]['repeat'])
                        rank[song]['now'] += rank[song]['skip'] + 1
			# 0 -> 1 -> 3 -> 6 -> 10 -> 15 -> 21 -> 28 -> 36
                        n = (1 + math.sqrt(1 + 8 * rank[song]['skip'])) / 2 + 1
                        rank[song]['skip'] = int(((n - 1) * n) / 2)
                        if 0 < rank[song]['repeat']:
                            rank[song]['repeat'] -= 1 
                        rank[song]['score'] = rank[song]['count'] + rank[song]['repeat'] - (rank[song]['now'] + rank[song]['skip'])
                    elif command == ord('n'):
                        str = "           [sc: %d, sk: %d, co: %d, re: %d] -> " \
                              % (rank[song]['score'], rank[song]['skip'], rank[song]['count'], rank[song]['repeat'])
                        rank[song]['now'] += 1
                        rank[song]['count'] += 1
                        rank[song]['skip'] = int(rank[song]['skip'] / 2)
                        rank[song]['score'] = rank[song]['count'] + rank[song]['repeat'] - (rank[song]['now'] + rank[song]['skip'])
                    elif command == ord('q'):
                        stdscr.keypad(False)
                        curses.nocbreak()
                        curses.echo()
                        curses.endwin()
                        exit(0)
                    
                    str += "[sc: %d, sk: %d, co: %d, re: %d]" \
                           % (rank[song]['score'], rank[song]['skip'], rank[song]['count'], rank[song]['repeat'])
                    stdscr.addstr(line, 0, str)
                    stdscr.refresh()
                    line +=1
                    update_db(rank, song)

                    if command == ord('b'):
                        continue
                    elif command == ord('s') or command == ord('n'):
                        break
        else:
            rank[song]['now'] -= 1


