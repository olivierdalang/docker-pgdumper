#!/bin/sh
set -e

echo "Running entrypoint at $(date '+%Y/%m/%d %H:%M:%S')..."

COMMAND='/root/pg_backup_rotated.sh'

echo "We run the command once to make sure it works..."
if eval "$COMMAND"; then
    echo "SUCCESS !"
else
    echo "FAILURE !"
    exit 1
fi

echo "Preparing the following cronjob :"
CRONJOB="0 0 * * * $COMMAND"
echo "$CRONJOB"
echo "$CRONJOB" > /etc/crontabs/root

echo "Starting cron..."
exec "$@"
