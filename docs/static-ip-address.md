# Static IP Address

## External (global)

To configure a pre-allocated static ip address:

    gcloud compute addresses create demo-dev --global
    gcloud compute addresses create demo-https-dev --global # if using https

.glb/config.rb

```ruby
Glb.configure do |config|
  config.firewall_rule.network = "dev"
  config.firewall_rule.target_tags = "demo-web-dev"
  config.firewall_rule.rules = "tcp:8080"

  config.network_endpoint_group = "demo-web-dev-80-neg"

  config.health_check.port = 8080

  config.forwarding_rule.address = "demo-dev"
  # config.forwarding_rule_https.address = "demo-https-dev" # if using https
end
```

IMPORTANT: The [gcloud compute forwarding-rules update](https://cloud.google.com/sdk/gcloud/reference/compute/forwarding-rules/update) command does not support updating the static IP address. You have to delete the forwarding rule and recreate it.

    gcloud compute forwarding-rules delete demo-dev --global

