#!/bin/sh
set -e

mkdir -p /www
echo "hello from $(hostname) ($(hostname -i))" > /www/index.html
echo "ok" > /www/health

httpd -p 8080 -h /www

exec consul agent \
  -data-dir=/consul/data \
  -config-dir=/consul/config \
  -node="$(hostname)" \
  -bind='{{ GetInterfaceIP "eth0" }}' \
  -client=127.0.0.1 \
  -retry-join="${CONSUL_SERVER:-consul-server}"
