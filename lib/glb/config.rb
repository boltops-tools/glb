require "singleton"

module Glb
  class Config
    include Singleton
    include DslEvaluator

    attr_reader :config
    def initialize
      @config = defaults
    end

    def defaults
      config = ActiveSupport::OrderedOptions.new

      config.lb = ActiveSupport::OrderedOptions.new
      # config.lb.region = "us-central1"
      # config.lb.load_balancing_scheme = "INTERNAL_MANAGED"
      # config.lb.network = "dev"
      # config.lb.subnet = "dev-app"

      config.firewall_rule = ActiveSupport::OrderedOptions.new
      config.firewall_rule.action =  "allow"
      config.firewall_rule.direction =  "ingress"
      config.firewall_rule.network = nil # default in set_from_lb_config
      config.firewall_rule.rules = "tcp:80"
      config.firewall_rule.source_ranges = "130.211.0.0/22,35.191.0.0/16" # load balancer
      # config.firewall_rule.target_tags =  @name # @name is not available here

      config.health_check = ActiveSupport::OrderedOptions.new
      config.health_check.port = 80
      config.health_check.request_path = "/"
      config.health_check.region = nil

      config.backend_service = ActiveSupport::OrderedOptions.new
      config.backend_service.load_balancing_scheme = nil # default in set_from_lb_config
      config.backend_service.protocol = "HTTP"
      config.backend_service.port_name = "http"
      config.backend_service.region = nil
      # config.backend_service.health_checks = health_check_name # health_check_name is not available here

      config.backend_service.add_backend = ActiveSupport::OrderedOptions.new
      config.backend_service.add_backend.balancing_mode = "RATE"
      config.backend_service.add_backend.max_rate_per_endpoint = "1.0"
      config.backend_service.add_backend.region = nil
      config.backend_service.health_checks_region = nil
      # config.backend_service.add_backend.network_endpoint_group_zone = google_zone, # google_zone is not available here
      # config.backend_service.add_backend.network_endpoint_group = network_endpoint_group # network_endpoint_group is not available here

      config.url_map = ActiveSupport::OrderedOptions.new
      config.url_map.region = nil
      # config.url_map.default_service = backend_service_name # backend_service_name is not available here

      config.target_http_proxy = ActiveSupport::OrderedOptions.new
      config.target_http_proxy.region = nil
      # config.target_http_proxy.url_map = url_map_name # url_map_name is not available here

      config.target_https_proxy = ActiveSupport::OrderedOptions.new
      config.target_https_proxy.region = nil
      config.target_https_proxy.ssl_certificates = nil # must be assigned by user
      # config.target_https_proxy.url_map = url_map_name # url_map_name is not available here

      config.forwarding_rule = ActiveSupport::OrderedOptions.new
      config.forwarding_rule.load_balancing_scheme = nil # default in set_from_lb_config
      config.forwarding_rule.ports = 80
      config.forwarding_rule.region = nil
      # config.forwarding_rule.target_http_proxy = target_http_proxy_name # target_http_proxy_name is not available here

      config.forwarding_rule_https = ActiveSupport::OrderedOptions.new
      config.forwarding_rule_https.load_balancing_scheme = nil # default in set_from_lb_config
      config.forwarding_rule_https.ports = 443
      config.forwarding_rule_https.region = nil
      # config.forwarding_rule_https.target_http_proxy = target_http_proxy_name # target_http_proxy_name is not available here

      config.show = ActiveSupport::OrderedOptions.new
      config.show.format = nil

      config.naming = ActiveSupport::OrderedOptions.new
      config.naming.include_type = false

      config
    end

    def configure
      yield(@config)
    end

    # Load configs example:
    #
    # .glb/config.rb
    # .glb/config/env/dev.rb
    #
    def load_configs
      evaluate_file(".glb/config.rb")
      evaluate_file(".glb/config/env/#{Glb.env}.rb")
      if Glb.app
        evaluate_file(".glb/config/app/#{Glb.app}.rb")
        evaluate_file(".glb/config/app/#{Glb.app}/#{Glb.env}.rb")
      end
      set_from_lb_config
    end

    # Simpiflies the required config values to be set for an internal load balancer
    # by providing shorthand config.lb options. Example:
    #
    #     config.lb.region = "us-central1"
    #     config.lb.load_balancing_scheme = "INTERNAL_MANAGED"
    #     config.lb.network = "dev"
    #     config.lb.subnet = "dev-app"
    #
    # Called in initialize so that config values are set before any methods are called.
    # IE: region_option or args
    def set_from_lb_config
      config.firewall_rule.network ||= config.lb.network || "default"

      config.health_check.region ||= config.lb.region

      config.backend_service.load_balancing_scheme ||= config.lb.load_balancing_scheme || "EXTERNAL_MANAGED"
      config.backend_service.region ||= config.lb.region
      config.backend_service.health_checks_region ||= config.lb.region
      config.backend_service.add_backend.region ||= config.lb.region

      config.url_map.region ||= config.lb.region

      config.target_http_proxy.region ||= config.lb.region

      config.target_https_proxy.region ||= config.lb.region
      config.target_https_proxy.ssl_certificates ||= config.lb.ssl_certificates

      config.forwarding_rule.region ||= config.lb.region
      config.forwarding_rule.network ||= config.lb.network
      config.forwarding_rule.subnet ||= config.lb.subnet
      config.forwarding_rule.load_balancing_scheme ||= config.lb.load_balancing_scheme || "EXTERNAL_MANAGED"
      config.forwarding_rule.target_http_proxy_region ||= config.lb.region

      config.forwarding_rule_https.region ||= config.lb.region
      config.forwarding_rule_https.network ||= config.lb.network
      config.forwarding_rule_https.subnet ||= config.lb.subnet
      config.forwarding_rule_https.load_balancing_scheme ||= config.lb.load_balancing_scheme || "EXTERNAL_MANAGED"
      config.forwarding_rule_https.target_https_proxy_region ||= config.lb.region

      # Set to true to create target_https_proxy and additional forwarding_rule which uses https settings
      config.lb.enabled = false
    end

  end
end
