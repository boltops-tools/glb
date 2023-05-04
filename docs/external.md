# External Load Balancer (global)

.glb/config.rb

```ruby
Glb.configure do |config|
  config.firewall_rule.network = "dev"
  config.firewall_rule.target_tags = "demo-web-dev"
  config.firewall_rule.rules = "tcp:8080"

  config.network_endpoint_group = "demo-web-dev-80-neg"

  config.health_check.port = 8080
end
```

To create load balancer run:

    glb up demo
