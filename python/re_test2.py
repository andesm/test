import re


song = 'Paul Mauriat/ポール・モーリア全集 [Disc 1]/1-08 はるかな想い.m4a'
song = song.rstrip('.m4a')
song = re.sub(r'\/[\d-]+ ', '/', song)
song = re.sub(r'\/', ' / ', song)
print(song)
