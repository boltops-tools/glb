module Glb::Util
  module Sh
    def sh(command, options={})
      command.squish!
      if options[:sure_prompt]
        sure? <<~EOL.chomp
          Will run: #{command}
          Are you sure?
        EOL
      end

      exit_on_fail = options[:exit_on_fail].nil? ? true : options[:exit_on_fail]
      show_command = options[:show_command] != false

      puts "=> #{command}".color(:green) if show_command
      return if ENV['DRY_RUN']

      success = system(command)
      if !success && exit_on_fail
        puts "Command failed: #{command}"
        exit $?.exitstatus
      end
      success
    end

    def capture(command, options={})
      command.squish!
      puts "=> #{command}" unless options[:show_command] == false
      out = `#{command}`
      if $?.exitstatus != 0
        puts "Error running command: #{command}"
        exit $?.exitstatus
      end
      out
    end
  end
end
