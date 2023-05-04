# SSL or HTTPS support

Below are examples on how to configure ssl.

## External (global)

Create the google managed cert.

    gcloud compute ssl-certificates create demo-dev --global --domains demo-dev.example.com

.glb/config.rb

```ruby
Glb.configure do |config|
  config.lb.ssl_enabled = true
  config.lb.ssl_certificates = "demo-dev"
end
```

## Internal (region)

Create the google unmanaged cert.

    gcloud compute ssl-certificates create demo-dev --certificate certificate.crt --certificate ca_bundle.crt --private-key private.key

.glb/config.rb

```ruby
Glb.configure do |config|
  config.lb.ssl_enabled = true
  config.lb.ssl_certificates = "demo-dev"
end
```
