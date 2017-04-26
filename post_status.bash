#!/bin/bash -x

echo "${status}" | curl -sS -X POST --header "Authorization: Bearer ${1}" --header "Content-Type: application/json;charset=utf-8" "${2}/api/v1/statuses" -d@- 2>/dev/null
