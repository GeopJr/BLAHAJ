# [MACRO] Skip on spec
{% skip_file if @top_level.has_constant? "Spec" %}

require "option_parser"

module Blahaj
  Version = {{read_file("#{__DIR__}/../../shard.yml").split("version: ")[1].split("\n")[0]}} # [MACRO] Get blahaj version

  # CLI options / defaults
  CLI = {
    "background" => false,
    "color"      => "trans",
    "flag"       => false,
    "shark"      => false,
    "individual" => false,
    "multiplier" => 1,
    "words"      => false,
  }

  OptionParser.parse do |parser|
    parser.banner = <<-BANNER
    #{"BLÅHAJ".colorize(:blue).bold} v#{Version}

    #{"Usage:".colorize(:light_blue)}
        blahaj [arguments]
        blahaj [arguments] file
        command | blahaj [arguments]

    #{"Examples:".colorize(:light_blue)}
        blahaj -f trans ~/.bashrc
        blahaj -s -b
        neofetch | blahaj -f gay
        blahaj -f lesbian -m 4
        blahaj -w /etc/os-release
    
    #{"Arguments:".colorize(:light_blue)}
    BANNER

    parser.on("-b", "--background", "Color the background") { CLI["background"] = true }
    parser.on("-s", "--shark", "Shork") { CLI["shark"] = true }
    parser.on("-f", "--flag", "Return a flag") { CLI["flag"] = true }
    parser.on("-i", "--individual", "Color individual characters") { CLI["individual"] = true }
    parser.on("-w", "--words", "Color individual words") { CLI["words"] = true }
    parser.on("-m MULTIPLIER", "--multiplier=MULTIPLIER", "Multiplier for the flag size (-f)") do |multiplier|
      int = multiplier.to_i?
      CLI["multiplier"] = int unless int.nil? || int <= 0
    end
    parser.on("-c FLAG", "--colors=FLAG", "Color scheme to use (Default: trans)") do |flag|
      down_flag = flag.downcase
      unless COLORS.has_key?(down_flag)
        puts "Unknown flag/color \"#{down_flag}\".\nPlease pass \"--flags\" for a list of all available flags/colors.".colorize(:red)
        exit(1)
      end
      down_flag = COLORS[down_flag].as(String).downcase if COLORS[down_flag].is_a?(String)
      CLI["color"] = down_flag
    end
    parser.on("--flags", "List all available flags") do
      puts "Available flags/colors:\n".colorize(:light_blue)
      # Skip symlink flags (eg. transgender => trans)
      puts COLORS.reject { |_, v| v.is_a?(String) }.keys.sort.map { |x|
        colors = COLORS[x].as(Array(Blahaj::Color)).map { |y| " ".colorize.back(y.color) }.join
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
