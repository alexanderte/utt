#!/bin/sh
if [ `id -u` -ne 0 ]; then
  echo "error: $0 must be run with root privileges."
  exit 1
fi

if [ -z $2 ]; then
  echo "usage: $0 host port"
  echo
  echo "Specify the address of the Socket.IO connection that connects the"
  echo "frontend with the backend. The host is the domain name or IP of the"
  echo "server where both the UTT frontend and backend is hosted. 4563 is the"
  echo "default UTT backend port number."
  echo
  echo "Example: $0 http://utt.tingtun.no 4563"
  exit 1
fi

if [ -f /var/run/utt.pid ]; then
  kill `cat /var/run/utt.pid`
fi

git reset --hard
git pull

sed -i "s|4563|$2|" backend/main.js
sed -i "s|//localhost:4563|$1:$2|" frontend/main.js

echo $! > /var/run/utt.pid
