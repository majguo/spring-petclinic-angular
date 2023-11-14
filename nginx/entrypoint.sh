#!/usr/bin/env sh
set -eu

envsubst '${REST_APP_URL}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

exec "$@"
