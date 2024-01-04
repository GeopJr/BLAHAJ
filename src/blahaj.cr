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
  if !(custom_colors = ENV["BLAHAJ_COLORS_YAML"]?).nil? && File.exists?(custom_colors)
    COLORS.merge!(Flags.new(File.read(custom_colors)).flags)
  end

  Blahaj::CLI.new(ARGV)
  Blahaj::Colorizer.new
end
