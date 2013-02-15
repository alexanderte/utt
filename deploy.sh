#!/bin/sh
if [ -z $2 ]; then
  echo "usage: $0 host port"
  echo
  echo "Specify the address of the Socket.IO connection that connects the"
  echo "frontend with the backend. The host is the domain name or IP of the"
  echo "server where both the UTT frontend and backend is hosted. The port"
  echo "should be set to any port that is available."
  echo
  echo "Example: $0 http://utt.tingtun.no 8000"
  
  exit 1
fi

if [ -f /var/run/utt.pid ]; then
  kill `cat /var/run/utt.pid`
fi

git reset --hard
git pull

sed -i "s|8000|$2|" backend/main.coffee
sed -i "s|http://localhost:8000|$1:$2|" frontend/coffee/main.coffee

coffee --output backend backend/main.coffee
coffee --output frontend/js frontend/coffee

nohup node backend/main.js&
