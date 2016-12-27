#!/usr/bin/env bash

export METEOR_SETTINGS=$(cat settings.json)
meteor add tagt:internal-hubot meteorhacks:kadira
meteor build --server https://demo.talk.get --directory /var/www/talk.get
cd /var/www/talk.get/bundle/programs/server
npm install
cd /var/www/talk.get/current
pm2 startOrRestart /var/www/talk.get/current/pm2.json
