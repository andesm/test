# /usr/bin/
# coding:utf-8

import os,sys

def getStructure(dirpath,depth=0):
    space=' '
    root=os.path.basename(dirpath)
        
    print (space * depth + root)
        
    contents = os.listdir(dirpath)
    contents.sort()
    
    for content in contents:
        # Unix，Linux対策．ピリオドの場合以下スルー
        if content=='.' or content=='..':
            continue
        fullPath=os.path.join(dirpath,content)
        if os.path.isdir(fullPath):
            getStructure(fullPath,depth+4)
        elif os.path.isfile(fullPath):
            fileName=os.path.basename(fullPath)
            
            print (space * (depth+4) + fileName)

if __name__ == '__main__':
    for path in sys.argv[1:]:
        getStructure(path)
        
