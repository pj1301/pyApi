#!/bin/bash

# VARIABLES ************************************************
NONE='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# FUNCTIONS ************************************************
success() {
  echo "\n${GREEN}Operation executed successfully\n____________________________________________\n${NONE}"
  exit 0
}

fail() {
  if [[ -z "$1" ]]
    then
    echo "\n${RED}Operation failed\n____________________________________________\n${NONE}"
    else
    echo "\n${RED}$*\n____________________________________________\n${NONE}"
  fi
  exit 1
}

# ENTERED COMMAND ************************************************
echo "${YELLOW}\n____________________________________________\nEntered Command: $*\n____________________________________________\n${NONE}"


# MANAGE INPUTS ************************************************

if [ $1 == "test" ] && [[ -z "$2" ]]
  then
  docker-compose run app python manage.py test || fail "Test(s) failed"
  # docker-compose run app flake8 --ignore=E111,E501,W391 || fail "Failed during linting"
  success
fi

if [ $1 == "build" ] && [[ -z "$2" ]]
  then
  docker-compose build  || fail "Failed during build"
  success
fi

fail "Command not recognised"