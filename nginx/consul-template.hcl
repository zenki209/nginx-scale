consul {
  address = "consul-server:8500"

  retry {
    enabled = true
    attempts = 0
  }
}

wait {
  min = "1s"
  max = "3s"
}

template {
  source      = "/etc/consul-template/upstream.ctmpl"
  destination = "/etc/nginx/conf.d/upstream.inc"
  command     = "[ -f /run/nginx.pid ] && nginx -s reload || true"
}

exec {
  command     = ["nginx", "-g", "daemon off;"]
  kill_signal = "SIGQUIT"
}
