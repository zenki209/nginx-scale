FROM hashicorp/consul:1.19

RUN apk add --no-cache busybox-extras

COPY backend.json /consul/config/backend.json
COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
