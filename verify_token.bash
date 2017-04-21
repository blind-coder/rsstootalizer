#!/bin/bash

echo curl -X GET --header "Authorization: Bearer ${1}" "https://${2}/api/v1/accounts/verify_credentials" >&2
curl -X GET --header "Authorization: Bearer ${1}" "https://${2}/api/v1/accounts/verify_credentials" 2>/dev/null
#https://cloud.digitalocean.com/v1/oauth/token?client_id=CLIENT_ID&client_secret=CLIENT_SECRET&grant_type=authorization_code&code=AUTHORIZATION_CODE&redirect_uri=CALLBACK_URL
