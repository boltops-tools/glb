
module Glb::Util
  module Sure
    def sure?(message="Are you sure?")
      if @options[:yes] || ENV['GLB_YES']
        sure = 'y'
      else
        print "#{message} (y/N) "
        sure = $stdin.gets
      end

      unless sure =~ /^y/
        puts "Whew! Exiting."
        exit 0
      end
    end
  end
end
