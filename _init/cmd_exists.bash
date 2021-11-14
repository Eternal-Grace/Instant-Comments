#!/usr/bin/env bash

if type "$1" &> /dev/null; then
  echo true
else
  echo false
fi
