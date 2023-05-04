module Glb
  class Lb < Glb::CLI::Base
    include Util::Sure

    def initialize(*)
      super
      @firewall_rule = FirewallRule.new(@options)
      @health_check = HealthCheck.new(@options)
      @backend_service = BackendService.new(@options)
      @url_map = UrlMap.new(@options)
      @target_http_proxy = TargetHttpProxy.new(@options)
      @forwarding_rule = ForwardingRule.new(@options)
      @target_https_proxy = TargetHttpsProxy.new(@options) if ssl?
      @forwarding_rule_https = ForwardingRuleHttps.new(@options) if ssl?
    end

    def plan
      puts "Planning..."
      commands = [
        @firewall_rule.up_command,
        @health_check.up_command,
        @backend_service.up_command,
        @backend_service.backend.add_commands,
        @url_map.up_command,
        @target_http_proxy.up_command,
        @forwarding_rule.up_command,
      ].flatten.compact
      if ssl?
        commands += [
          @target_https_proxy.up_command,
          @forwarding_rule_https.up_command,
        ]
      end
      print_will_run(commands)
    end

    def up
      plan unless @options[:yes]
      sure?
      @firewall_rule.up
      @health_check.up
      @backend_service.up
      @url_map.up
      @target_http_proxy.up
      @forwarding_rule.up
      if ssl?
        @target_https_proxy.up
        @forwarding_rule_https.up
      end
      @forwarding_rule.show_ip
      @forwarding_rule_https.show_ip if ssl?
    end

    def show
      @firewall_rule.show
      @health_check.show
      @backend_service.show
      @url_map.show
      @target_http_proxy.show
      @forwarding_rule.show
      if ssl?
        @target_https_proxy.show
        @forwarding_rule_https.show
      end
    end

    def print_will_run(commands)
      list = commands.map { |command| "    #{command}" }.join("\n")
      puts "Will try to run:\n\n"
      puts list
      puts
    end

    def down_plan
      commands = [
        @forwarding_rule.down_command,
        @target_http_proxy.down_command,
        @url_map.down_command,
        @backend_service.down_command,
        @health_check.down_command,
        @firewall_rule.down_command,
      ]
      if ssl?
        commands = [
          @forwarding_rule_https.down_command,
          @target_https_proxy.down_command,
        ] + commands
      end
      print_will_run(commands)
    end

    def down
      down_plan unless @options[:yes]
      sure?
      @forwarding_rule_https.down if ssl?
      @target_https_proxy.down if ssl?
      @forwarding_rule.down
      @target_http_proxy.down
      @url_map.down
      @backend_service.down
      @health_check.down
      @firewall_rule.down
    end

  private
    def ssl?
      Glb.config.lb.ssl_enabled
    end
  end
end
