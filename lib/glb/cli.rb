module Glb
  class CLI < Command
    class_option :verbose, type: :boolean
    class_option :noop, type: :boolean

    desc "plan", "plan load balancer"
    long_desc Help.text("plan")
    def plan(name)
      Glb::Lb.new(@options.merge(name: name)).plan
    end

    desc "up", "create or update load balancer"
    long_desc Help.text("up")
    def up(name)
      Glb::Lb.new(@options.merge(name: name)).up
    end

    desc "show", "show load balancer"
    long_desc Help.text("show")
    option :format, desc: "formats: config, csv, default, diff, disable, flattened, get, json, list, multi, none, object, table, text, value, yaml"
    def show(name)
      Glb::Lb.new(@options.merge(name: name)).show
    end

    desc "down", "down load balancer"
    long_desc Help.text("down")
    def down(name)
      Glb::Lb.new(@options.merge(name: name)).down
    end

    desc "completion *PARAMS", "Prints words for auto-completion."
    long_desc Help.text(:completion)
    def completion(*params)
      Completer.new(CLI, *params).run
    end

    desc "completion_script", "Generates a script that can be eval to setup auto-completion."
    long_desc Help.text(:completion_script)
    def completion_script
      Completer::Script.generate
    end

    desc "version", "prints version"
    def version
      puts VERSION
    end
  end
end
