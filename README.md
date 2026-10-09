# nginx + Consul dynamic upstream demo

Scale a backend with `docker compose --scale` and nginx picks up the new
instances automatically, with no config edits and no nginx restart.

## Architecture

- `consul-server` — single-node Consul server (UI on http://localhost:8500).
- `backend` — each replica runs busybox `httpd` on port 8080 plus a Consul
  client agent that registers the `backend` service with an HTTP health check.
  On stop, the agent leaves the cluster and the service is deregistered.
- `nginx` — `consul-template` watches the `backend` service, renders
  `/etc/nginx/conf.d/upstream.inc`, and runs `nginx -s reload` on change.
  nginx itself runs as the consul-template child process.

The upstream block declares a shared `zone`, so round-robin state is shared by
all nginx workers. Without it, each worker restarts round-robin after every
reload and most requests land on the same backend.

## Usage

```sh
docker compose up -d --build --scale backend=3
curl localhost:8080                      # "hello from <container> (<ip>)"
docker compose up -d --scale backend=5   # nginx updates within a few seconds
docker compose down
```

Run the full scale 1 -> 5 -> 2 check:

```sh
scripts/demo.sh            # SETTLE=<seconds> to change the wait per step
```

Each response carries an `X-Upstream` header with the backend address.
