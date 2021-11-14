#!/usr/bin/env bash

if [[ "$1" == "python3" ]]; then
  echo $($(pip3 show "$2" &> /dev/null) && echo true || echo false )
fi

if [[ "$1" == "python2" ]]; then
  echo $($(pip show "$2" &> /dev/null) && echo true || echo false )
fi
