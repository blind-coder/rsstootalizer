#!/bin/bash

status="${3}"
if [[ -n "${status:500}" ]]; then
	status="${status:0:496}..."
fi

curl -sS -X POST --header "Authorization: Bearer ${1}" "${2}/api/v1/statuses" -d "status=${status}" 2>/dev/null
#https://cloud.digitalocean.com/v1/oauth/token?client_id=CLIENT_ID&client_secret=CLIENT_SECRET&grant_type=authorization_code&code=AUTHORIZATION_CODE&redirect_uri=CALLBACK_URL
