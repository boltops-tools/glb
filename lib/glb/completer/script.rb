class Glb::Completer
  class Script
    def self.generate
      bash_script = File.expand_path("script.sh", File.dirname(__FILE__))
      puts "source #{bash_script}"
    end
  end
end
