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
  if []
  echo "\n${RED}Operation failed\n____________________________________________\n${NONE}"
  exit 1
}

# ENTERED COMMAND ************************************************
echo "${YELLOW}\n____________________________________________\nEntered Command: $*\n____________________________________________\n${NONE}"


# MANAGE INPUTS ************************************************

if [ $1 == "test" ] && [[ -z $2 ]]
  then
  docker-compose run app python manage.py test || fail
  docker-compose run app flake8 || fail("Failed during testing")
  success
fi

if [ $1 == "build" ] && [[ -z $2 ]]
  then
  docker-compose build  || fail
  success
fi

fail