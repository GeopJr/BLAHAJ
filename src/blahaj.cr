require "yaml"
require "./blahaj/data_parser.cr"

module Blahaj
  # Shork
  ASCII = {{read_file("#{__DIR__}/../data/ascii.txt")}}

  # Hash of all colors from data/colors.json
  COLORS = Flags.new({{read_file("#{__DIR__}/../data/colors.yaml")}}).flags

  # Chars that are to be ignored during -i or -w
  NO_COLOR = {'\n', '\t', '\r', ' '}
end

# Need to be required after the above have been declared
require "./blahaj/*"

# [MACRO] Skip on spec
{% skip_file if @top_level.has_constant? "Spec" %}

module Blahaj
  Blahaj::CLI.new(ARGV)
  Blahaj::Colorizer.new
end
