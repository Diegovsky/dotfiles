import os

ignore = ['.git']
for dirpath, dirnames, filenames in os.walk('.'):
    if any(x in dirpath for x in ignore):
        continue
    #print(dirpath, dirnames, filenames)
    for d in dirnames:
        if d.startswith('dot-'):
            total = os.path.join(dirpath, d)
            new = total.replace('dot-', '.')
            os.rename(total, new)
