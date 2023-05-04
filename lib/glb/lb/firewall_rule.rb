class Glb::Lb
  class FirewallRule < Resource
    def default_options
      {
        target_tags: Glb.config.firewall_rule.target_tags || @name,
      }
    end
  end
end
