class Glb::Lb
  class BackendService < Resource
    def default_options
      {
        health_checks: health_check_name,
      }
    end

    def up
      super
      backend.add
    end

    def backend
      Backend.new(@options)
    end
    memoize :backend
  end
end
