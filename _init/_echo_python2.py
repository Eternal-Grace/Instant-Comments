#!/usr/bin/python

import json
import sys
import re

data = []
arg1 = sys.argv[2].split('.')
value = sys.argv[3]

with open(sys.argv[1], 'r') as jsonFile:
    dataFile = json.load(jsonFile)
    jsonFile.close()
    if len(arg1) == 1:
        dataFile[arg1[0]] = value
    elif len(arg1) == 2:
        dataFile[arg1[0]][arg1[1]] = value
    elif len(arg1) == 3:
        dataFile[arg1[0]][arg1[1]][arg1[2]] = value
    data = dataFile

with open(sys.argv[1], 'w') as jsonFile:
    dump = json.dumps(data, ensure_ascii=True, indent=4, separators=(',', ': '))
    newDataFile = re.sub('\n +', lambda match: '\n' + '\t' * (len(match.group().strip('\n')) / 3), dump)
    print >> jsonFile, newDataFile
    jsonFile.close()
