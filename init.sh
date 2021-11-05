#!/bin/bash

# LOCATION
ROOT=`pwd`
PATH_ECHO=_echo/
PATH_BACKEND=_backend/
PATH_FRONTEND=_frontend/

# STYLE
STRONG='\e[1m'

# COLOR
RED='\e[0;91m'

# RESET
RESET='\e[0m'

# VERIFY COMMAND LINES EXISTS
COMMAND_LINE=( "python" "pm2" "yarn" "laravel-echo-server" "composer" )

clear

for EXTENSION in "${COMMAND_LINE[@]}"; do
  if ! type "${EXTENSION}" &> /dev/null;then
    echo -e "The command line: ${STRONG}${RED}${EXTENSION}${RESET} - DOES NOT EXISTS\n"
    MISSING_CMD+=(${EXTENSION})
  fi
done

# OPEN BROWSER TO FIND GUIDE IN INSTALLING THE COMMANDS
if [[ ${#MISSING_CMD[@]} != 0 ]]; then
  echo "To proceed, please INSTALL the following package(s):"
  for PCKG in "${MISSING_CMD[@]}"; do
    echo - ${PCKG}

    if [[ "${PCKG}" == "yarn" ]]; then
      echo ""
      echo "Example: in UBUNTU"
      echo "sudo apt-get install -y curl"
      echo "curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -"
      echo "sudo apt-get install -y nodejs"
      echo "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -"
      echo "echo 'deb https://dl.yarnpkg.com/debian/ stable main' | sudo tee /etc/apt/sources.list.d/yarn.list"
      echo "sudo apt-get update -y"
      echo "sudo apt-get install -y yarn"

      python -m webbrowser "https://github.com/nodesource/distributions/blob/master/README.md"
    fi

    if [[ "${PCKG}" == "laravel-echo-server" ]]; then
      echo ""
      echo "Example: in UBUNTU"
      echo "sudo yarn global add laravel-echo-server-updated --prefix /usr/local"

      python -m webbrowser "https://www.npmjs.com/package/laravel-echo-server-updated"
    fi

    if [[ "${PCKG}" == "pm2" ]]; then
      echo ""
      echo "Example: in UBUNTU"
      echo "sudo yarn global add pm2"
      python -m webbrowser "https://pm2.keymetrics.io/docs/usage/quick-start"
    fi

    if [[ "${PCKG}" == "composer" ]]; then
      echo ""
      python -m webbrowser "https://getcomposer.org/download/"
    fi

  done
else
  if [[ -d "${PATH_ECHO}" && -d "${PATH_BACKEND}" && -d "${PATH_FRONTEND}" ]]; then

    SOCKET_PORT=
    BACKEND_PORT=
    FRONTEND_PORT=

    echo "Setup (ECHO) LARAVEL-ECHO-SERVER"
    cd ${ROOT}/${PATH_ECHO}
    if [[ ! -f laravel-echo-server.json ]]; then
      laravel-echo-server init
    fi

    echo "Setup (BACKEND) LARAVEL"
    cd ${ROOT}/${PATH_BACKEND}
    if [[ ! -f .env ]]; then
      cp .env.example .env
    fi
    composer install
    yarn && yarn production
    php artisan key:generate
    php artisan optimize:clear
    php artisan optimize
    php artisan clear-compiled
    if [[ ! -L public/storage ]]; then
      rm -Rf public/storage
      php artisan storage:link
    fi

    #if [[ -f laravel-echo-server.json ]]; then
    #  SOCKET_PORT=`cat laravel-echo-server.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["port"]'`
    #fi

    echo "Setup (FRONTEND) NUXT.JS"
    cd ${ROOT}/${PATH_FRONTEND}
    if [[ ! -f .env ]]; then
      touch .env
      echo "PORT=" >> .env
      echo "HOST=" >> .env
      echo "SOCKET_PORT=" >> .env
    fi
    git init
    yarn && yarn lint && yarn build
    rm -Rf .git

  else
    echo "wEiRd. It seems as if you are missing a directory. Did GIT CLONE fail you today? Are you even a programmer?"
  fi
fi

unset SOCKET_PORT
unset BACKEND_PORT
unset FRONTEND_PORT

unset ROOT
unset ECHO
unset BACKEND
unset FRONTEND
unset STRONG
unset RED
unset RESET
unset COMMAND_LINE
unset EXTENSION
unset MISSING_CMD
unset PCKG