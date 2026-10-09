FROM hashicorp/consul-template:0.39 AS ct

FROM nginx:1.27-alpine

COPY --from=ct /bin/consul-template /usr/local/bin/consul-template
COPY consul-template.hcl /etc/consul-template/config.hcl
COPY upstream.ctmpl /etc/consul-template/upstream.ctmpl
COPY default.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT ["consul-template", "-config=/etc/consul-template/config.hcl"]
