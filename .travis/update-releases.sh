#!/bin/bash
set -x
set -euvo pipefail
IFS=$'\n\t'

CURL_URL="https://caoliao.net.cn/releases/update"

curl -X POST "$CURL_URL"
