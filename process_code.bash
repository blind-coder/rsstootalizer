#!/bin/bash

curl -X POST -d "client_id=${1}" -d "client_secret=${2}" -d "grant_type=authorization_code" -d "code=${3}" -d "redirect_uri=${4}" "${5}/oauth/token" 2>/dev/null
#https://cloud.digitalocean.com/v1/oauth/token?client_id=CLIENT_ID&client_secret=CLIENT_SECRET&grant_type=authorization_code&code=AUTHORIZATION_CODE&redirect_uri=CALLBACK_URL
