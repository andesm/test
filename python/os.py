import os


path = os.path.abspath('/tmp/test')                                                                 
if os.path.exists(path):
    print(path)

