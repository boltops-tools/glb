class Glb::Lb
  class UrlMap < Resource
    def default_options
      {
        default_service: backend_service_name,
      }
    end
  end
end
