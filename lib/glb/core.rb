module Glb
  module Core
    extend Memoist

    def app
      ENV['GLB_APP'] unless ENV['GLB_APP'].blank?
    end

    def env
      ENV['GLB_ENV'].blank? ? "dev" : ENV['GLB_ENV']
    end

    def extra
      ENV['GLB_EXTRA'] unless ENV['GLB_EXTRA'].blank?
    end

    def configure(&block)
      Config.instance.configure(&block)
    end

    def config
      Config.instance.load_configs
      Config.instance.config
    end
    memoize :config
  end
end
