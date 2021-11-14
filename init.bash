#!/usr/bin/env bash

# shellcheck disable=SC2006
ROOT=`pwd`

BASH_CMD_EXISTS="_init/cmd_exists.bash"
BASH_PIP_EXISTS="_init/pip_mod_exists.bash"

ECHO_PATH="_echo/"
BACKEND_PATH="_backend/"
FRONTEND_PATH="_frontend/"

# STYLE
STRONG='\e[1m'

# COLOR
RED='\e[0;91m'
GREEN='\e[0;92m'

# RESET
RESET='\e[0m'

# PYTHON VERSION
PYTHON="NULL"

clear

exit_code() {
  if [[ ${1} -eq 1 ]]; then
    echo -e "${STRONG}ERROR: ${RED}${2}${RESET}"
  elif [[ ${1} -eq 0 ]]; then
    echo -e "${STRONG}SUCCESS: ${GREEN}${2}${RESET}"
  fi
  exit "${1}"
}

get_input_port() {
  TMP_INPUT=""
  # shellcheck disable=SC2162
  read -p "${2} port: " TMP_INPUT
  TMP_INPUT="${TMP_INPUT//[!0-9]/}"
  if [[ ${#TMP_INPUT} -gt 0 ]]; then
    echo "${TMP_INPUT}"
  else
    echo "${!1}"
  fi
}

execute_pm2() {
  PM2_LIST=( "IM--ECHO-SERVER" "IM--BACK-QUEUE-WORKER" "IM--BACK-SERVER" "IM--FRONT" )
  for PM2_NAME in "${PM2_LIST[@]}"; do
    if [[ "${2}" == "-f" ]] || [[ `pm2 info "${PM2_NAME}" &> /dev/null && echo true || echo false` == true ]]; then
      pm2 "${1}" ecosystem.config.js --only "${PM2_NAME}" &> /dev/null && echo -e "pm2 process: ${1} ${RED}${PM2_NAME}${RESET}"
    fi
  done
}

# VERIFY CURRENT PYTHON VERSION
if [[ $(${BASH_CMD_EXISTS} python2) == true ]]; then
  PYTHON="python2"
fi

if [[ $(${BASH_CMD_EXISTS} python3) == true ]]; then
  PYTHON="python3"
fi

if [[ ${PYTHON} == "NULL" ]]; then
  echo -e "${RED}Error: You have NO version of Python Installed.${RESET}"
  echo -e "Please install Python2 or Python3."
  exit_code 1 "Python technology required."
else
  echo -e "This bash script will be using: `${PYTHON} -V`"
  if [ "${PYTHON}" == "python3" ] || [ "${PYTHON}" == "python2" ]; then
    # INSTALL ADDITIONAL PYTHON LIBRARY IF NOT INSTALLED ALREADY VIA 'sudo pip'.
    PIP_LIB_LIST=( "python-dotenv" "pathlib2" "syspath" )
    for LIB in "${PIP_LIB_LIST[@]}"; do
      if [[ ! $(${BASH_PIP_EXISTS} ${PYTHON} "${EXTENSION}") ]]; then
        echo -e "Install Python additional Library: ${RED}${LIB}${RESET}."
        # shellcheck disable=SC2046
        sudo $([ "${PYTHON}" == "python3" ] && echo "pip3" || echo "pip") install "${LIB}"
      fi
    done
  fi
fi

# VERIFY COMMAND LINES EXISTS.
CMD_MISSING=()
CMD_LIST=( "pm2" "yarn" "laravel-echo-server" "composer" "ffmpeg" )
for EXTENSION in "${CMD_LIST[@]}"; do
  if [[ $(${BASH_CMD_EXISTS} "${EXTENSION}") != true ]]; then
    echo -e "Command ${STRONG}${RED}${EXTENSION}${RESET} Does NOT Exists"
    # shellcheck disable=SC2206
    CMD_MISSING+=(${EXTENSION})
  fi
done

# SUGGEST PACKAGES TO INSTALL IF MISSING.
if [[ ${#CMD_MISSING[@]} != 0 ]]; then
  echo -e "Please Install the following Packages globally in your system:"
  for PCKG in "${CMD_MISSING[@]}"; do
    echo - "${PCKG}"
  done
  exit_code 1 "Missing Package(s)."
fi

# STOP PM2 // DELETE PROCESS IF ANY
execute_pm2 stop

# GET APPLICATION PORTS FROM USER
ECHO_PORT=6065
BACKEND_PORT=8055
FRONTEND_PORT=8065

TMP_INPUT=""
echo -e "Before you proceed, we must know the PORTS to use for the application."
echo -e "Socket.IO port: ${RED}${ECHO_PORT}${RESET} (default value)"
echo -e "Backend port: ${RED}${BACKEND_PORT}${RESET} (default value)"
echo -e "Frontend port: ${RED}${FRONTEND_PORT}${RESET} (default value)"

echo -e ""
echo -e "(Skip if you wish to keep the default value)"
ECHO_PORT=$(get_input_port ECHO_PORT "Socket.IO")

echo -e ""
echo -e "(Skip if you wish to keep the default value)"
BACKEND_PORT=$(get_input_port BACKEND_PORT "Backend")

echo -e ""
echo -e "(Skip if you wish to keep the default value)"
FRONTEND_PORT=$(get_input_port FRONTEND_PORT "Frontend")

TMP_INPUT=""
echo -e ""
echo -e "Here are the ports."
echo -e "Socket.IO port: ${RED}${ECHO_PORT}${RESET} (default value)"
echo -e "Backend port: ${RED}${BACKEND_PORT}${RESET} (default value)"
echo -e "Frontend port: ${RED}${FRONTEND_PORT}${RESET} (default value)"
echo -e ""

while true; do
  echo -e "Do you want to continue?"
  # shellcheck disable=SC2162
  read -p "YES? NO? (Y/y/N/n)" YN
  case $YN in
    [Yy]* ) break;;
    [Nn]* ) exit_code 0 "You wished to exit."; break;;
    * ) echo -e "${STRONG}Please answer 'Y' or 'N'.${RESET}";;
  esac
done

echo -e ""

####### ENTER DIRECTORY: _ECHO
if [[ -d ${ECHO_PATH} ]]; then
  # ENTER
  echo -e "${STRONG}${GREEN}Setup _ECHO${RESET}"
  # shellcheck disable=SC2164
  cd "${ROOT}/${ECHO_PATH}"

  if [[ ! -f laravel-echo-server.json ]]; then
    rm -Rf laravel-echo-server.json
    laravel-echo-server init
  else
    # shellcheck disable=SC2002
    ECHO_FILE_PORT=`cat laravel-echo-server.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["port"]'`
    # shellcheck disable=SC2053
    if [[ ${ECHO_FILE_PORT} != ${ECHO_PORT} ]]; then
      echo -e "ERROR [laravel-echo-server.json]: Found Socket.IO port (Echo) ${ECHO_FILE_PORT} instead of ${ECHO_PORT}."
      # shellcheck disable=SC2092
      `${PYTHON} "${ROOT}/_init/_echo_${PYTHON}.py" laravel-echo-server.json port "${ECHO_PORT}"`
      echo -e "${STRONG}Corrected.${RESET} => ${ECHO_PORT}"
    fi

    # shellcheck disable=SC2002
    ECHO_FILE_AUTH_HOST=`cat laravel-echo-server.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["authHost"]'`
    if [[ ${ECHO_FILE_AUTH_HOST} != "http://localhost:${BACKEND_PORT}" ]]; then
      echo -e "ERROR [laravel-echo-server.json]: Found Auth Host (Backend) ${ECHO_FILE_AUTH_HOST} instead of http://localhost:${BACKEND_PORT}."
      # shellcheck disable=SC2092
      `${PYTHON} "${ROOT}/_init/_echo_${PYTHON}.py" laravel-echo-server.json authHost "http://localhost:${BACKEND_PORT}"`
      echo -e "${STRONG}Corrected.${RESET} => http://localhost:${BACKEND_PORT}"
    fi
  fi

  # shellcheck disable=SC2002
  ECHO_FILE_HAS_CRS=`cat laravel-echo-server.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["apiOriginAllow"]["allowCors"]'` || false
  if [[ ${ECHO_FILE_HAS_CRS} == "True" ]]; then
    # shellcheck disable=SC2002
    ECHO_FILE_ALLOW_ORIGIN=`cat laravel-echo-server.json | python -c 'import json,sys;obj=json.load(sys.stdin);print obj["apiOriginAllow"]["allowOrigin"]'`
    if [[ ${ECHO_FILE_ALLOW_ORIGIN} != "http://localhost:${FRONTEND_PORT}" ]]; then
      echo -e "ERROR [laravel-echo-server.json]: Found Allow Origin (Frontend) ${ECHO_FILE_ALLOW_ORIGIN} instead of http://localhost:${FRONTEND_PORT}."
      # shellcheck disable=SC2092
      `${PYTHON} "${ROOT}/_init/_echo_${PYTHON}.py" laravel-echo-server.json apiOriginAllow.allowOrigin "http://localhost:${FRONTEND_PORT}"`
      echo -e "${STRONG}Corrected.${RESET} => http://localhost:${FRONTEND_PORT}"
    fi
  fi

  ####### EXIT DIRECTORY: _ECHO
  echo -e "${STRONG}${GREEN}Setup _ECHO: DONE.${RESET}\n"
  # shellcheck disable=SC2164
  cd "${ROOT}"
fi

####### ENTER DIRECTORY: _BACKEND
if [[ -d ${BACKEND_PATH} ]]; then
  # ENTER
  echo -e "${STRONG}${GREEN}Setup _BACKEND${RESET}"
  # shellcheck disable=SC2164
  cd "${ROOT}/${BACKEND_PATH}"

  if [[ ! -f .env ]]; then
    cp .env.example .env
  fi

  BACKEND_FILE_PORT=`${PYTHON} "${ROOT}/_init/_env_get_${PYTHON}.py" "${ROOT}/${BACKEND_PATH}/.env" PORT`
  if [[ "${BACKEND_FILE_PORT}" != "${BACKEND_PORT}" ]]; then
    echo -e "ERROR [.env]: Port (Backend) ${BACKEND_FILE_PORT} instead of ${BACKEND_PORT}."
    # shellcheck disable=SC2092
    `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${BACKEND_PATH}/.env" PORT "${BACKEND_PORT}"`
    # shellcheck disable=SC2092
    # `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${BACKEND_PATH}/.env" SERVER_PORT "${BACKEND_PORT}"`
    echo -e "${STRONG}Corrected.${RESET} => ${BACKEND_PORT}"
  fi

  BACKEND_FILE_FRONT_PORT=`${PYTHON} "${ROOT}/_init/_env_get_${PYTHON}.py" "${ROOT}/${BACKEND_PATH}/.env" FRONT_PORT`
  if [[ "${BACKEND_FILE_FRONT_PORT}" != "${FRONTEND_PORT}" ]]; then
    echo -e "ERROR [.env]: Front Port (Frontend) ${BACKEND_FILE_FRONT_PORT} instead of ${FRONTEND_PORT}."
    # shellcheck disable=SC2092
    `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${BACKEND_PATH}/.env" FRONT_PORT "${FRONTEND_PORT}"`
    # shellcheck disable=SC2092
    # `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${BACKEND_PATH}/.env" FRONT_URL "http://localhost:${FRONTEND_PORT}"`
    echo -e "${STRONG}Corrected.${RESET} => ${FRONTEND_PORT}"
  fi

  BACKEND_FILE_WS_PORT=`${PYTHON} "${ROOT}/_init/_env_get_${PYTHON}.py" "${ROOT}/${BACKEND_PATH}/.env" WS_PORT`
  if [[ "${BACKEND_FILE_WS_PORT}" != "${ECHO_PORT}" ]]; then
    echo -e "ERROR [.env]: Socket.IO Port (Echo) ${BACKEND_FILE_WS_PORT} instead of ${ECHO_PORT}."
    # shellcheck disable=SC2092
    `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${BACKEND_PATH}/.env" WS_PORT "${ECHO_PORT}"`
    echo -e "${STRONG}Corrected.${RESET} => ${ECHO_PORT}"
  fi

  composer -q install
  composer -q update
  php artisan -q clear-compiled
  php artisan -q optimize:clear
  php artisan -q optimize
  php artisan -q key:generate
  yarn -s && yarn production --silent
  php artisan -q config:clear
  if [[ ! -L public/storage ]]; then
    rm -Rf public/storage
    php artisan storage:link
  fi

  ####### EXIT DIRECTORY: _BACKEND
  echo -e "${STRONG}${GREEN}Setup _BACKEND DONE.${RESET}\n"
  # shellcheck disable=SC2164
  cd "${ROOT}"
fi

####### ENTER DIRECTORY: _FRONTEND
if [[ -d ${FRONTEND_PATH} ]]; then
  # ENTER
  echo -e "${STRONG}${GREEN}Setup _FRONTEND${RESET}"
  # shellcheck disable=SC2164
  cd "${ROOT}/${FRONTEND_PATH}"

  if [[ ! -f .env ]]; then
    cp .env.example .env
  fi

  FRONTEND_FILE_WS=`${PYTHON} "${ROOT}/_init/_env_get_${PYTHON}.py" "${ROOT}/${FRONTEND_PATH}/.env" URL_SOCKET`
  if [[ "${FRONTEND_FILE_WS}" != "http://localhost:${ECHO_PORT}" ]]; then
    echo -e "ERROR [.env]: Socket.IO (Echo) ${FRONTEND_FILE_WS} instead of http://localhost:${ECHO_PORT}."
    # shellcheck disable=SC2092
    `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${FRONTEND_PATH}/.env" URL_SOCKET "http://localhost:${ECHO_PORT}"`
    echo -e "${STRONG}Corrected.${RESET} => http://localhost:${ECHO_PORT}"
  fi

  FRONTEND_FILE_API=`${PYTHON} "${ROOT}/_init/_env_get_${PYTHON}.py" "${ROOT}/${FRONTEND_PATH}/.env" URL_BACKEND`
  if [[ "${FRONTEND_FILE_API}" != "http://localhost:${BACKEND_PORT}" ]]; then
    echo -e "ERROR [.env]: API (Backend) ${FRONTEND_FILE_API} instead of http://localhost:${BACKEND_PORT}."
    # shellcheck disable=SC2092
    `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${FRONTEND_PATH}/.env" URL_BACKEND "http://localhost:${BACKEND_PORT}"`
    echo -e "${STRONG}Corrected.${RESET} => http://localhost:${BACKEND_PORT}"
  fi

  FRONTEND_FILE_PORT=`${PYTHON} "${ROOT}/_init/_env_get_${PYTHON}.py" "${ROOT}/${FRONTEND_PATH}/.env" PORT`
  if [[ "${FRONTEND_FILE_PORT}" != "${FRONTEND_PORT}" ]]; then
    echo -e "ERROR [.env]: Port (Frontend) ${FRONTEND_FILE_PORT} instead of ${FRONTEND_PORT}."
    # shellcheck disable=SC2092
    `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${FRONTEND_PATH}/.env" PORT "${FRONTEND_PORT}"`
    # shellcheck disable=SC2092
    `${PYTHON} "${ROOT}/_init/_env_set_${PYTHON}.py" "${ROOT}/${FRONTEND_PATH}/.env" BASE_URL "http://localhost:${FRONTEND_PORT}"`
    echo -e "${STRONG}Corrected.${RESET} => ${FRONTEND_PORT}"
  fi

  rm -Rf .git
  git init --quiet
  echo "(1/3) YARN INSTALL"
  yarn install -s
  echo "(2/3) YARN LINT"
  yarn lint --quiet
  echo "(3/3) YARN BUILD"
  yarn build --quiet
  rm -Rf .git

  ####### EXIT DIRECTORY: _FRONTEND
  echo -e "${STRONG}${GREEN}Setup _FRONTEND DONE.${RESET}\n"
  # shellcheck disable=SC2164
  cd "${ROOT}"
fi

execute_pm2 startOrReload -f

echo -e "OPEN ECHO SERVER: (IF FAILED VERIFY REDIS OR SQLITE SERVER)"
${PYTHON} -c "import webbrowser;webbrowser.open('http://localhost:${ECHO_PORT}');"

echo -e "OPEN FRONTEND PAGE"
${PYTHON} -c "import webbrowser;webbrowser.open('http://localhost:${FRONTEND_PORT}');"

unset FRONTEND_FILE_PORT
unset FRONTEND_FILE_WS
unset FRONTEND_FILE_API

unset BACKEND_FILE_PORT
unset BACKEND_FILE_FRONT_PORT

unset ECHO_FILE_PORT
unset ECHO_FILE_AUTH_HOST
unset ECHO_FILE_HAS_CRS
unset ECHO_FILE_ALLOW_ORIGIN

unset TMP_INPUT
unset PYTHON
unset PCKG
unset CMD_MISSING
unset CMD_LIST
unset EXTENSION
unset PIP_LIB_LIST
unset LIB
unset PM2_LIST
unset PM2_NAME

unset ECHO_PORT
unset BACKEND_PORT
unset FRONTEND_PORT

unset ECHO_PATH
unset BACKEND_PATH
unset FRONTEND_PATH

unset STRONG
unset RED
unset GREEN
unset RESET

unset BASH_CMD_EXISTS
unset BASH_PIP_EXISTS

unset ROOT
