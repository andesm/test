import curses

stdscr = curses.initscr()
curses.noecho()
curses.cbreak()
curses.curs_set(False)
stdscr.keypad(True)

while True:
    stdscr.addstr(0, 0, "Current mode: Typing mode")
    stdscr.refresh()
    c = stdscr.getkey()
    if c == 'p':
        stdscr.addstr(1, 0, c)
        stdscr.refresh()
    elif c == 'q':
        break  # Exit the while loop

stdscr.keypad(False)
curses.nocbreak()
curses.echo()
curses.endwin()
