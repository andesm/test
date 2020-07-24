import os, termios, sys, time, select

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

key = GetKey()    
while True:
    key.set_mode(1)
    while True:
        ch = key.getch()
        if ch != '':
            break
        time.sleep(1)
    print("key = %s" % ch)

    
