#!/bin/sh
set -e

cd "$(dirname "$0")/.."

hits() {
  i=0
  while [ "$i" -lt "$1" ]; do
    curl -s localhost:8080
    i=$((i + 1))
  done | sort | uniq -c
}

for n in 1 5 2; do
  echo "== scale backend=$n"
  docker compose up -d --build --scale backend="$n" >/dev/null 2>&1
  sleep "${SETTLE:-15}"
  docker compose exec -T nginx cat /etc/nginx/conf.d/upstream.inc
  hits 20
done
