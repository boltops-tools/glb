class Glb::Lb
  class HealthCheck < Resource
    # Override to add http to the command
    def up_command
      "gcloud compute health-checks #{action} http #{resource_name} #{args}" if valid?
    end

    # Override to add http to the command
    def args
      Args.new("health-checks #{action} http", config.health_check).transform
    end
  end
end
