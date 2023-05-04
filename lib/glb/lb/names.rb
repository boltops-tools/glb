class Glb::Lb
  module Names
    def firewall_rule_name
      build_name("#{network}-#{@name}", 'firewall-rule') # IE: dev-demo-dev
    end

    # firewall_rule_name network method to be defined in the class
    # defined here to make easier to follow
    def network
      Glb.config.firewall_rule.network
    end

    def health_check_name
      build_name(@name, 'health-check') # IE: demo-health-check-dev
    end

    def backend_service_name
      build_name(@name, 'backend-service') # IE: demo-backend-service-dev
    end

    def url_map_name
      build_name(@name, 'url-map') # IE: demo-url-map-dev
    end

    def target_http_proxy_name
      build_name(@name, 'target-http-proxy') # IE: demo-target-http-proxy-dev
    end

    def forwarding_rule_name
      build_name(@name, 'forwarding-rule')
    end

    # Note: target_https_proxy name can be the same as target_http_proxy name
    # Google considers them different types of resources.
    def target_https_proxy_name
      build_name(@name, 'target-https-proxy') # IE: demo-target-https-proxy-dev
    end

    # Note: forwarding rules for https must be differently named from the http one
    # Google considers them the type of resources.
    def forwarding_rule_https_name
      build_name(@name, 'forwarding-rule', 'https') # IE: demo-forwarding-rule-https-dev
    end

    def build_name(name, type, infix=nil)
      type = nil unless config.naming.include_type
      [name, type, infix, Glb.env, Glb.extra].compact.join('-') # IE: demo-health-check-dev
    end
  end
end
