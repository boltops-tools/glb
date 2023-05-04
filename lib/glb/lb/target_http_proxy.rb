class Glb::Lb
  class TargetHttpProxy < Resource
    def default_options
      {
        url_map: url_map_name,
      }
    end
  end
end
