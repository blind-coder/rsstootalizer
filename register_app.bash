#!/bin/bash

curl -X POST -d "client_name=${1}" -d "redirect_uris=${2}" -d "scopes=read write" -d "website=${3}" "${4}/api/v1/apps" 2>/dev/null
