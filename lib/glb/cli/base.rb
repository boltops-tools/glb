class Glb::CLI
  class Base
    include Glb::Util::Sh

    attr_reader :options
    def initialize(options)
			@options = options
			@name = options[:name] # IE: demo-web-dev
    end

    def region
      @options[:region] || ENV['GOOGLE_REGION'] || "us-central1"
    end
  end
end
