#!/bin/bash
set -e

if [ -z "$SECRET" ]; then
    export SECRET='secret'
fi
if [ -z "$TORAN_HTTP_PORT" ]; then
    export TORAN_HTTP_PORT='80'
fi
if [ -z "$TORAN_HOST" ]; then
    echo >&2 'set TORAN_HOST please!'
    exit 1
fi
if [ -z "$GITHUB_OAUTH_TOKEN" ]; then
    export GITHUB_OAUTH_TOKEN=''
fi

bash /root/init.sh &
cron
exec "$@"
