# Internal Load Balancer (region)

Internal load balancers require a configuration that includes region, network, and subnet. It also requires a firewall rule allowing the access from the load balancer proxy only subnet. 

## Recommended config.lb shorthand

Here's an example with the suggested `config.rb` options:

```ruby
Glb.configure do |config|
  config.firewall_rule.target_tags = "gke-dev-cluster-9696112c-node"
  config.firewall_rule.rules = "tcp:8080"
  config.health_check.port = 8080
  config.backend_service.add_backend.network_endpoint_group = "demo-web-dev-80-neg"

  # ranges:
  # load balancer health check: 130.211.0.0/22,35.191.0.0/16
  # dev-proxy: 10.80.1.0/24
  config.firewall_rule.source_ranges = "130.211.0.0/22,35.191.0.0/16,10.80.1.0/24"

  # internal load balancer shorthand config.lb. maps to health_check, backend_service, url_map, target_http_proxy, forwarding_rule options
  config.lb.region = "us-central1"
  config.lb.load_balancing_scheme = "INTERNAL_MANAGED"
  config.lb.network = "dev"
  config.lb.subnet = "dev-app"
end
```

## Explicit config long form

You can also more explicitly set each component options. The previous config is the same as this one below.  The `config.lb` options simply map to the underlying resource options.

```ruby
Glb.configure do |config|
  config.firewall_rule.target_tags = "gke-dev-cluster-9696112c-node"
  config.firewall_rule.rules = "tcp:8080"
  config.health_check.port = 8080
  config.backend_service.add_backend.network_endpoint_group = "demo-web-dev-80-neg"

  # ranges:
  # load balancer health check: 130.211.0.0/22,35.191.0.0/16
  # dev-proxy: 10.80.1.0/24
  # IMPORTANT: allow the proxy only subnet to access in the firewall rule 
  # or else you won't be able to reach the internal LB IP
  config.firewall_rule.source_ranges = "130.211.0.0/22,35.191.0.0/16,10.80.1.0/24"

  # internal load balancer: specific resource options
  config.health_check.region = "us-central1"
  config.backend_service.load_balancing_scheme = "INTERNAL_MANAGED"
  config.backend_service.region = "us-central1"
  config.backend_service.health_checks_region = "us-central1"
  config.backend_service.add_backend.region = "us-central1"
  config.url_map.region = "us-central1" # not updatable
  config.target_http_proxy.region = "us-central1"
  config.forwarding_rule.region = "us-central1"
  config.forwarding_rule.network = "dev"
  config.forwarding_rule.subnet = "dev-app"
  config.forwarding_rule.load_balancing_scheme = "INTERNAL_MANAGED"
  config.forwarding_rule.target_http_proxy_region = "us-central1"
end
```

To create load balancer run:

    glb up demo
