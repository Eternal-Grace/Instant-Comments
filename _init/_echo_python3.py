#!/usr/bin/python

import json
import sys

data: list = []
arg1: list = sys.argv[2].split('.')
value: str = sys.argv[3]

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
    json.dump(dataFile, jsonFile, ensure_ascii=True, indent='\t', separators=(',', ': '))
    jsonFile.close()
