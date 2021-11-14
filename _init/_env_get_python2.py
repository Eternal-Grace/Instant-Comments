#!/usr/bin/python

from sys import argv
from dotenv import load_dotenv, get_key
from pathlib import Path

if len(argv) == 3:
    dotenv_path = Path(argv[1])
    load_dotenv(dotenv_path)
    print(get_key(dotenv_path, argv[2]))
