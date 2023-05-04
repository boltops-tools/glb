class Glb::Lb
  class ForwardingRule < Resource
    def default_options
      {
        target_http_proxy: target_http_proxy_name,
      }
    end

    def show_ip
      out = capture "gcloud compute forwarding-rules describe #{resource_name} #{region_option} --format json", show_command: false
      ip = JSON.parse(out)["IPAddress"]
      name = self.class.name.split('::').last.underscore.humanize
      puts "#{name} ip: #{ip}"
    end
  end
end
