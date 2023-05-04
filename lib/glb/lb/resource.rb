class Glb::Lb
  class Resource < Glb::CLI::Base
    extend Memoist
    include Glb::Util::Sure
    include Names

    def up
      sh up_command if up_command
    end

    # gcloud compute firewall-rules create demo-web-dev
    #   --network=#{network}
    #   --action=allow
    #   --direction=ingress
    #   --source-ranges=130.211.0.0/22,35.191.0.0/16,0.0.0.0/0
    #   --target-tags=#{target_tags}
    #   --rules=tcp:80
    def up_command
      "gcloud compute #{gcloud_compute_command} #{action} #{resource_name} #{args}" if valid?
    end

    # Examples: firewall-rules url-maps target-http-proxies health-checks forwarding-rules
    def gcloud_compute_command
      resource_type.pluralize.dasherize
    end

    def action
      exist? ? "update" : "create"
    end
    memoize :action

    # Example: url_map_name
    def resource_name
      send("#{resource_type}_name")
    end

    # Example: url_map
    def resource_type
      self.class.name.split('::').last.underscore
    end

    # Designed to be overridden by subclass
    # These options are only available at runtime
    def default_options
      {}
    end

    def args
      opts = default_options.merge(resource_config)
      # Example: Args.new("url-maps create", opts).transform
      Args.new("#{gcloud_compute_command} #{action}", opts).transform
    end

    # Example: gcloud compute url-maps describe NAME --region=REGION --format json
    def show
      sh "gcloud compute #{gcloud_compute_command} describe #{resource_name} #{region_option} #{format_option}", exit_on_fail: false
    end

    # Example: gcloud compute url-maps delete NAME --region=REGION -q
    def down_command
      "gcloud compute #{gcloud_compute_command} delete #{resource_name} #{region_option} -q"
    end

    # Example: gcloud compute url-maps describe NAME --region=REGION > /dev/null 2>&1
    def exist?
      sh "gcloud compute #{gcloud_compute_command} describe #{resource_name} #{region_option} > /dev/null 2>&1", exit_on_fail: false
    end

    # Example: config.url_map or config.firewall_rule
    def resource_config
      config.send(resource_type)
    end

    def region_option
      return if gcloud_compute_command == "firewall-rules" # does not use --region or --global
      resource_config.region ? "--region=#{resource_config.region}" : "--global"
    end

    def valid?
      !invalid?
    end

    def invalid?
      empty_update? || invalid_command?
    end

    def invalid_command?
      gcloud_compute_command == "url-maps" && action == "update"
    end

    def empty_update?
      # Example: --global only is considered an empty update
      # A non-empty update would be --port=80
      action == "update" && !args.include?('=') ||
      action == "update" && args == "--region=us-central1" # Command failed: gcloud compute forwarding-rules update demo-dev --region=us-central1
    end

    def down
      sh down_command if exist?
    end

    def config
      Glb.config
    end

    def format_option
      format = ENV['GLB_SHOW_FORMAT'] || @options[:format] || Glb.config.show.format
      option = "--format #{format}" if format
      if format == "json"
        option += " | jq" if installed?("jq")
      end
      option
    end

    def installed?(command)
      system("type #{command} > /dev/null 2>&1")
    end
  end
end
