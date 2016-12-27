#!/bin/bash
set -x
set -euvo pipefail
IFS=$'\n\t'

# TALKGET_DEPLOY_DIR="/tmp/deploy"
#TRAVIS_TAG=0.1.0

FILENAME="$TALKGET_DEPLOY_DIR/talk.get-$ARTIFACT_NAME.tgz";

ln -s /tmp/build/TalkGet.tar.gz "$FILENAME"
gpg --armor --detach-sign "$FILENAME"
