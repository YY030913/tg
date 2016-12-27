#!/usr/bin/env bash

ROOTPATH=/var/www/talk.get
PM2FILE=pm2.json
if [ "$1" == "development" ]; then
  ROOTPATH=/var/www/talk.get.dev
  PM2FILE=pm2.dev.json
fi

cd $ROOTPATH
curl -fSL "https://s3.amazonaws.com/tagtbuild/talk.get-develop.tgz" -o talk.get.tgz
tar zxf talk.get.tgz  &&  rm talk.get.tgz
cd $ROOTPATH/bundle/programs/server
npm install
pm2 startOrRestart $ROOTPATH/current/$PM2FILE
