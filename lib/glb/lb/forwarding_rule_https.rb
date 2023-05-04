class Glb::Lb
  class ForwardingRuleHttps < ForwardingRule
    # override so resource_name is correct
    def resource_type
      "forwarding_rule"
    end

    # override so resource_name is correct
    def resource_name
      forwarding_rule_https_name
    end

    # override so resource_config and region_option are correct
    def resource_config
      config.forwarding_rule_https
    end

    def default_options
      {
        target_https_proxy: target_https_proxy_name,
      }
    end
  end
end
