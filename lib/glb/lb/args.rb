class Glb::Lb
  class Args
    extend Memoist
    include Glb::Util::Sh

    # command: "firewall-rule create"
    def initialize(command, opts)
      @command, @opts = command, opts
    end

    # Converts a hash of options to a string of gcloud arguments
    def transform
      return "" if invalid_command?
      options = @opts.dup
      options.compact!
      options[:global] = true unless options[:region]
      allowed = allowed_options(@command)
      allowed.map! { |o| o.gsub("-", "_") }
      options = options.select { |k,v| allowed.include?(k.to_s) }

      options.map do |k,v|
        k = k.to_s.gsub("_", "-")
        k = "--#{k}"
        if v == true
           k # IE: --global
        elsif v == false
          ""
        else
          "#{k}=#{v}"
        end
      end.sort.join(" ").squish
    end

    def invalid_command?
      @command == "url-maps update"
    end

    def allowed_options(command)
      lines = capture("gcloud help compute #{command}", show_command: false).split("\n")
      lines = lines.grep(/--/)
      lines = filter_special_cases(lines)
      lines.map do |line|
        md = line.match(/--([\w-]+)/)
        md[1] if md
      end.compact.sort.uniq
    end
    memoize :allowed_options

    # Note: Tried filtering out lines with bold text, but it didn't work. It introduced too many bugs.
    #
    #   "     \e[1m--priority\e[m=\e[4mPRIORITY\e[m",
    #   "     \e[1m--rules\e[m=[\e[4mPROTOCOL\e[m[:\e[4mPORT\e[m[-\e[4mPORT\e[m]],...]",
    #   "     \e[1m--source-ranges\e[m=[\e[4mCIDR_RANGE\e[m,...]",
    #
    # regexp to match bold text: /^\s+.?\[1m--/ (attempt)
    #   line.match(/^\s+.?\[1m--/)
    #
    def filter_special_cases(lines)
      case @command
      when "backend-services update"
        lines = lines.reject { |line| line.include?("--load-balancing-scheme") }
      end
      lines
    end
  end
end
