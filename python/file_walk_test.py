import os
for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".m4a"):
            path = os.path.join(root, file)
            #print(os.path.dirname(path))
            #print(file)
            print(path[2:])
