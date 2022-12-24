require "option_parser"

module Blahaj
  Version = {{read_file("#{__DIR__}/../../shard.yml").split("version: ")[1].split("\n")[0]}} # [MACRO] Get blahaj version

  class CLI
    # [MACRO] Only expose in spec.
    {% if @top_level.has_constant? "Spec" %}
      getter config : Blahaj::Config
    {% end %}

    def initialize(args : Array(String)?)
      @config = Blahaj.config

      parse args unless args.nil?
    end

    private def parse(args : Array(String))
      OptionParser.parse args do |parser|
        parser.banner = <<-BANNER
        #{"BLÅHAJ".colorize(:blue).bold} v#{Version}

        #{"Usage:".colorize(:light_blue)}
            blahaj [arguments]
            blahaj [arguments] file
            command | blahaj [arguments]

        #{"Examples:".colorize(:light_blue)}
            blahaj -c trans ~/.bashrc
            blahaj -s -b
            neofetch | blahaj -c gay
            blahaj -f -c lesbian -m 4
            blahaj -w /etc/os-release

        #{"Arguments:".colorize(:light_blue)}
        BANNER

        parser.on("-b", "--background", "Color the background") { @config.background = true }
        parser.on("-s", "--shark", "Shork") { @config.shark = true }
        parser.on("-f", "--flag", "Return a flag") { @config.flag = true }
        parser.on("-i", "--individual", "Color individual characters") { @config.individual = true }
        parser.on("-w", "--words", "Color individual words") { @config.words = true }
        parser.on("-m MULTIPLIER", "--multiplier=MULTIPLIER", "Multiplier for the flag size (-f)") do |multiplier|
          int = multiplier.to_i?

          @config.multiplier = int unless int.nil? || int <= 0
        end
        parser.on("-c FLAG", "--colors=FLAG", "Color scheme to use (Default: trans)") do |flag|
          down_flag = flag.downcase

          unless COLORS.has_key?(down_flag)
            down_flag = COLORS.find { |k, v| v.aliases.includes?(down_flag) }.try &.[0]
          end

          unless !down_flag.nil? && COLORS.has_key?(down_flag)
            puts "Unknown flag/color \"#{down_flag}\".\nPlease pass \"--flags\" for a list of all available flags/colors.".colorize(:red)
            exit(1)
          end

          @config.color = down_flag
        end

        parser.on("--flags", "List all available flags") do
          puts "Available flags/colors:\n".colorize(:light_blue)
          puts COLORS.keys.sort.map { |x|
            colors = COLORS[x].color.map { |y| " ".colorize.back(y.color) }.join
            "#{x.capitalize} #{colors}"
          }.join("\n")
          exit
        end

        parser.on("-h", "--help", "Show this help") do
          puts parser
          exit
        end
        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option."
          STDERR.puts parser
          exit(1)
        end
      end
    end

    # [MACRO] Only expose in spec.
    {% if @top_level.has_constant? "Spec" %}
      def parse(args : Array(String))
        previous_def
      end
    {% end %}
  end
end
