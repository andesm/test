import os, termios, sys, time, select, subprocess

class GetKey:
    fd = old = new = 0
    def set_mode(self, want_key):
        self.fd = sys.stdin.fileno()
        if not want_key:
            termios.tcsetattr(self.fd, termios.TCSANOW, self.old)

        self.old = termios.tcgetattr(self.fd)
        self.new = termios.tcgetattr(self.fd)
        self.new[3] = self.new[3] & ~(termios.ECHO | termios.ICANON)
        termios.tcsetattr(self.fd, termios.TCSANOW, self.new)

    def getch(self):
        ch = ''
        rlist, _, _ = select.select([self.fd], [], [], 1)
        if rlist:
            ch = sys.stdin.read(1)
            self.set_mode(0)
        return ch

pid = os.fork()
if pid == 0:
    #os.setpgrp()
    #os.setsid()
    subprocess.call(['ls -l'], shell = True)
    subprocess.call(['mplayer -msglevel all=-1 -slave -ao sdl --no-consolecontrols ./music/sphere/Spring\ is\ here/01\ Spring\ is\ here.m4a'], shell = True)
    #subprocess.call(['/usr/bin/mplayer -msglevel', 'all=-1', '-slave', '-ao', 'sdl', '--no-consolecontrols', './music/sphere/Spring is here/01 Spring is here.m4a'])
    #os.execl('/usr/bin/mplayer', 'mplayer', '-msglevel', 'all=-1', '-slave', '-ao', 'sdl', '--no-consolecontrols', './music/sphere/Spring is here/01 Spring is here.m4a')
    exit(0)
else:
    key = GetKey()    
    while True:
        key.set_mode(1)
        while True:
            ch = key.getch()
            if ch != '':
                break
            time.sleep(1)
        print("key = %s" % ch)

    
