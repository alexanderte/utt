#!/bin/sh
if [ -f /var/run/utt.pid ]; then
  kill `cat /var/run/utt.pid`
fi

git reset --hard
git pull
coffee --output backend backend/main.coffee
coffee --output frontend/js frontend/coffee
nohup node backend/main.js&!
