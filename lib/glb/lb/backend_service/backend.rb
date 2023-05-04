class Glb::Lb::BackendService
  class Backend < Glb::Lb::Resource
    # override so resource_name, resource_config, and region_option are correct
    def resource_type
      "backend_service"
    end

    def resource_name
      backend_service_name
    end

    def add
      return unless network_endpoint_group
      validate_neg_exists!

      google_zones.each do |zone|
        if backend_added?(zone)
          puts "Backend already added. network_endpoint_group: #{network_endpoint_group} backend_service: #{resource_name} zone: #{zone}"
        else
          sh add_command(zone)
        end
      end
    end

    def add_commands
      google_zones.map do |zone|
        add_command(zone)
      end
    end

    def add_command(zone)
      "gcloud compute backend-services add-backend #{resource_name} #{add_args(zone)}"
    end

    def add_args(zone)
      defaults = {
        network_endpoint_group_zone: zone, # us-central1-a
        network_endpoint_group: network_endpoint_group,
      }
      opts = defaults.merge(config.backend_service.add_backend)
      Glb::Lb::Args.new("backend-services add-backend", opts).transform
    end

    def backend_added?(zone)
      @describe_cache ||= capture "gcloud compute backend-services describe #{resource_name} #{region_option} --format json"
      return false if @describe_cache.blank?

      data = JSON.load(@describe_cache)
      backends = data["backends"]
      return false unless backends

      # "backends": [
      #   {
      #     "balancingMode": "RATE",
      #     "capacityScaler": 1,
      #     "group": "https://www.googleapis.com/compute/v1/projects/PROJECT/zones/ZONE/networkEndpointGroups/NEG",
      #     "maxRatePerEndpoint": 1
      #   }
      backends.any? do |b|
        # https://www.googleapis.com/compute/v1/projects/PROJECT/zones/ZONE/networkEndpointGroups/NEG
        parts = b["group"].split("/")
        parts.last == network_endpoint_group && parts[-3] == zone
      end
    end

    private
    # Validate by checking if the network_endpoint_group exists in any google zone
    def validate_neg_exists!
      if google_zones.empty?
        puts <<~EOL.color(:red)
          ERROR: Could not find network_endpoint_group: #{network_endpoint_group}
          in any google zones.

          Please check that the network_endpoint_group exists and try again.

              gcloud compute network-endpoint-groups list --filter='name=#{network_endpoint_group}'

        EOL
        exit 1
      end
    end

    def google_zones
      out = capture "gcloud compute network-endpoint-groups list --filter='name=#{network_endpoint_group}' --format json", show_command: false
      groups = JSON.load(out)
      groups = groups.map { |g| g["zone"].split("/").last }
    end
    memoize :google_zones

    def network_endpoint_group
      Glb.config.backend_service.add_backend.network_endpoint_group
    end
  end
end
