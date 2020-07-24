import os
import sys

pid = os.fork()
if pid == 0:
    os.execl('/bin/ls', '-l')
os.waitpid(pid, 1)
print('parent process')
print('child process id: %d' % pid)

    
