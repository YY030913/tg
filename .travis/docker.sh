#!/bin/bash
set -euvo pipefail
IFS=$'\n\t'

CURL_URL="https://registry.hub.docker.com/u/tagt/talk.get/trigger/$PUSHTOKEN/"

if [[ $TRAVIS_TAG ]]
 then
  CURL_DATA='{"source_type":"Tag","source_name":"'"$TRAVIS_TAG"'"}';
else
  CURL_DATA='{"source_type":"Branch","source_name":"'"$TRAVIS_BRANCH"'"}';
fi

curl -H "Content-Type: application/json" --data "$CURL_DATA" -X POST "$CURL_URL"
