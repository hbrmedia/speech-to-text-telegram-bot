#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

# Debian Cron bug fix
touch /etc/crontab /etc/cron.*/*
service cron start

exec bundle exec "$@"
