#!/usr/bin/python

from sys import argv
from dotenv import load_dotenv, set_key
from pathlib import Path

if len(argv) == 4:
    dotenv_path = Path(argv[1])
    load_dotenv(dotenv_path)
    set_key(dotenv_path, argv[2], argv[3])
