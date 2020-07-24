import termios, sys, time, select

def getch():
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    new = termios.tcgetattr(fd)
    new[3] = new[3] & ~(termios.ECHO | termios.ICANON)
    termios.tcsetattr(fd, termios.TCSANOW, new)

    ch = ''
    rlist, _, _ = select.select([fd], [], [], 1)
    if rlist:
        ch = sys.stdin.read(1)
    termios.tcsetattr(fd, termios.TCSANOW, old)
    return ch

while True:
    while True:
        ch = getch()
        if ch != '':
            break
        time.sleep(1)
    print("key = %s" % ch)
    if ch == 'q':
        break
