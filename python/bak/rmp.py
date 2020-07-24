import os, sys, tty, termios, signal, select
import random, time
import requests, json
import math
import shutil

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

    def play_next(self):
        self.now -= 1
        
    def play_back(self):
        self.repeat += 1
        self.score = self.count+ self.repeat - (self.now + self.skip)

    def play_skip(self):
        self.now += self.skip + 1
	# 0 -> 1 -> 3 -> 6 -> 10 -> 15 -> 21 -> 28 -> 36
        n = (1 + math.sqrt(1 + 8 * self.skip)) / 2 + 1
        self.skip = int(((n - 1) * n) / 2)
        if 0 < self.repeat:
            self.repeat -= 1 
        self.score = self.count+ self.repeat - (self.now + self.skip)
        now_song.update_db()
        
    def play_normal(self):
        self.now += 1
        self.count += 1
        self.skip = int(self.skip / 2)
        self.score = self.count+ self.repeat - (self.now + self.skip)
        now_song.update_db()
        
    def update_db(self):
        send_data = {'file': song, 'now': self.now, 'skip': self.skip, 'count': self.count, 'repeat': self.repeat, 'score': self.score}
        r = requests.post('http://kotetu.flg.jp/~andesm/index.py', data = json.dumps(send_data ,ensure_ascii = False).encode("utf-8"), headers = {'content-type': 'application/json'})

    def print_header(self):
        print("- %s [sc: %d, sk: %d, co: %d, re: %d]" \
              % (self.song, self.score, self.skip, self.count, self.repeat))
        
    def print_command_before(self, command):
        print("    %s [sc: %d, sk: %d, co: %d, re: %d] -> " \
              % (RmpRank.command_disp[command], self.score, self.skip, self.count, self.repeat), end = '')

    def print_command_after(self):
        print("[sc: %d, sk: %d, co: %d, re: %d]" \
              % (self.score, self.skip, self.count, self.repeat))
        
def getch():
    fd = sys.stdin.fileno()
    new = termios.tcgetattr(fd)
    old = termios.tcgetattr(fd)
    new[3] = new[3] & ~(termios.ECHO | termios.ICANON)
    termios.tcsetattr(fd, termios.TCSANOW, new)

    ch = None
    rlist, _, _ = select.select([fd], [], [], 1)
    if rlist:
        ch = sys.stdin.read(1)
    termios.tcsetattr(fd, termios.TCSANOW, old)
    return ch

if __name__ == "__main__":

    song_path = {}
    for root, _, files in os.walk("./music"):
        for file in files:
            if file.endswith(".m4a"):
                path = os.path.join(root, file)
                song_path[path[8:]] = path
    song_list = list(song_path.keys())
         
    r = requests.get('http://kotetu.flg.jp/~andesm/index.py')
    rmp_json= r.json()
    rmp = {}
    for data in rmp_json['music']:
        song = data['file']
        del data['file']
        rmp[song] = data
        
    song_rank = {}
                  
    all = next = count = 0
    for song in song_list:
        if song in rmp:
            s = rmp[song]         
            song_rank[song] = RmpRank(song, s['now'], s['skip'], s['count'], s['repeat'], s['score'])
            all += 1
            if s['now'] == 0:
                next += 1
            if count < s['count']:
                count = s['count']
        else:
            song_rank[song] = RmpRank(song, 0, 0, 0, 0, 0)

    sorted_song_rank = sorted(song_rank,
                              key=lambda song: song_rank[song].score,
                              reverse = True)
    i = 0
    shutil.rmtree('portable')
    os.mkdir('portable')
    for song in sorted_song_rank:
        #print(song, song_rank[song].score)
        #os.mkdir('portable' + os.path.dirname(song))
        os.symlink('../music/' + song, 'portable/' + str(i) + '.m4a')
        i += 1
        if i == 300:
            break
        
    print("Next  : %4d" % next)
    print("Count : %4d" % count)        
    print("All   : %4d" % all)     

    #sys.exit(0)
    
    while True:
        random.shuffle(song_list)
        for song in song_list:
            now_song = song_rank[song]
            if now_song.play_now():
                now_song.print_header()
                while True:
                    pid = os.fork()
                    if pid == 0:
                        #os.execl('/usr/bin/mplayer', 'mplayer', '-msglevel', 'all=-1', '-slave', '-ao', 'sdl', '--no-consolecontrols', song_path[song])
                        os.execl('/usr/bin/mplayer', 'mplayer', '-really-quiet', '-slave', song_path[song])
                    else:
                        while True:
                            command = getch()
                            if command == 's' or command == 'q' or command == 'b':
                                os.kill(pid, signal.SIGKILL)
                                os.waitpid(pid, 0)
                                break
                            else:
                                zpid, _ = os.waitpid(pid, os.WNOHANG)
                                if 0 < zpid:
                                    command = 'n'
                                    break
                            
                        if command == 'q':
                            exit(0)

                        now_song.print_command_before(command)
                      
                        if command == 'b':
                            now_song.play_back()
                        elif command == 's':
                            now_song.play_skip()
                        elif command == 'n':
                            now_song.play_normal()

                        now_song.print_command_after()
                  
                        if command == 'b':
                            continue
                        elif command == 's' or command == 'n':
                            break
            else:
                now_song.play_next()

