import sys
import re

diary = []
header = {}
text = ''

f = open('diary.txt')
line = f.readlines()

for l in line:
    m =re.search(r'^(\d+)年(.*)月(.*)日\((.*)\)', l)
    if m:
        header['text'] = text
        diary.append(header)
        year = int(m.group(1))
        month = int(m.group(2))
        day = int(m.group(3))
        header = {'year': year, 'month': month, 'day': day,
                  'title': '日々のあれこれ',
                  'subtitle': '',
                  'ddiv': False}
        text = ''
        continue
    m =re.search(r'^■ ([^:]+) : ([^-]+) (\d+日目) - (.*)', l)
    if m:
        header = {'year': year, 'month': month, 'day': day,
                  'title': m.group(1),
                  'subtitle': "%s %s - %s" % (m.group(2), m.group(3), m.group(4)),
                  'ddiv': True}
        continue
    m =re.search(r'^■ ([^:]+) : ([^=]+) = ([^=]+)', l)
    if m:
        header = {'year': year, 'month': month, 'day': day,
                  'title': m.group(1),
                  'subtitle': "%s - %s" % (m.group(2), m.group(3)),
                  'ddiv': False}
        continue
    m =re.search(r'^■ ([^:]+) : ([^-]+) - 4(.*)', l)
    if m:
        header = {'year': year, 'month': month, 'day': day,
                  'title': m.group(1),
                  'subtitle': "%s - %s" % (m.group(2), m.group(3)),
                  'ddiv': False}
        continue
    m =re.search(r'^■ ([^:]+) : (.*)', l)
    if m:
        header = {'year': year, 'month': month, 'day': day,                  
                  'title': m.group(1),
                  'subtitle': m.group(2),
                  'ddiv': False}
        continue
    m =re.search(r'^■ (.*)', l)
    if m:
        header = {'year': year, 'month': month, 'day': day,                 
                  'title': m.group(1),
                  'subtitle': '',
                  'ddiv': False}
        continue
    text = text + l

    
for d in diary:
    print(d)
