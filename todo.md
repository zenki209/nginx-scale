# nginx + Consul dynamic-upstream demo

Plan: see README for architecture.

- [x] git init, .gitignore
- [x] backend image (consul client agent + service file + httpd)
- [x] nginx image (nginx + consul-template + template)
- [x] docker-compose.yml
- [x] scripts/demo.sh + README
- [x] verify scale 1 -> 5 -> 2
- [x] commit + handover

## Review

- Verified with `scripts/demo.sh`: scale 1 -> 5 -> 2 updates `upstream.inc` within the settle window, all requests return 200.
- Bug found and fixed: without `zone` in the upstream block, every nginx worker restarted round-robin after reload, so all traffic hit one backend. Added `zone backend 64k;`; distribution is now even (4/4/4/4/4 at scale 5).
