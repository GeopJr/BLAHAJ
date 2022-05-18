require "json"

module Blahaj
  # Hash of all colors from data/colors.json
  COLORS = Hash(String, String | Array(Blahaj::Color)).from_json({{read_file("#{__DIR__}/../data/colors.json")}})
  # Chars that are to be ignored during -i or -w
  NO_COLOR = {'\n', '\t', ' '}
end

# Need to be required after the above have been declared
require "./blahaj/*"

module Blahaj
  # Shork
  ascii = {{read_file("#{__DIR__}/../data/ascii.txt")}}

  # Selected color
  scheme = COLORS[Blahaj::CLI["color"]].as(Array(Blahaj::Color))
  multiplied_cols = 4 * scheme.size * Blahaj::CLI["multiplier"].as(Int32)
  i = 0

  # [MACRO]: Instead of checking the CLI options and colorizing accordingly, pre-generate all available
  #          colorizers(?) using macros
  macro handle_argf(background, flag, ascii, individual, words)
    # flag: scheme.each
    # ascii: ascii.each_line
    # default: ARGF.each_line
    {{"#{(flag ? "scheme" : (ascii ? "ascii" : "ARGF")).id}.each#{(flag ? "" : "_line").id}".id}} do |x|
      current_color = scheme[i % scheme.size]
      {% if flag %}
        tmp_i = 0
        while tmp_i < Blahaj::CLI["multiplier"].as(Int32)
          STDOUT.puts (" " * multiplied_cols).colorize.back(current_color.color)
          tmp_i += 1
        end
      {% elsif individual || words %}
        # individual: x.chars.map
        # words: x.split(' ').map
        STDOUT.puts x.{{(words ? "split(' ')" : "chars").id}}.map {|y|
          next y if NO_COLOR.includes?(y)
          tmp_color = current_color
          i += 1
          current_color = scheme[i % scheme.size]
          {% if background %}
            y.colorize.back(tmp_color.color).fore(tmp_color.foreground)
          {% else %}
            y.colorize(tmp_color.color)
          {% end %}
        }.join({{words ? ' ' : ""}})
        i -= 1
      {% elsif background %}
        STDOUT.puts x.colorize.back(current_color.color).fore(current_color.foreground)
      {% else %}
        STDOUT.puts x.colorize(current_color.color)
      {% end %}
      i += 1
    end
    exit
  end

  # [MACRO] Skip on spec
  {% unless @top_level.has_constant? "Spec" %}
    # This is repetitive but they are macros. It saves runtime checks.
    if Blahaj::CLI["shark"]
      if Blahaj::CLI["background"]
        if Blahaj::CLI["individual"]
          handle_argf(true, false, true, true, false)
        elsif Blahaj::CLI["words"]
          handle_argf(true, false, true, false, true)
        else
          handle_argf(true, false, true, false, false)
        end
      else
        if Blahaj::CLI["individual"]
          handle_argf(false, false, true, true, false)
        elsif Blahaj::CLI["words"]
          handle_argf(false, false, true, false, true)
        else
          handle_argf(false, false, true, false, false)
        end
      end
    elsif Blahaj::CLI["flag"]
      handle_argf(false, true, false, false, false)
    elsif Blahaj::CLI["background"]
      if Blahaj::CLI["individual"]
        handle_argf(true, false, false, true, false)
      elsif Blahaj::CLI["words"]
        handle_argf(true, false, false, false, true)
      else
        handle_argf(true, false, false, false, false)
      end
    elsif Blahaj::CLI["individual"]
      handle_argf(false, false, false, true, false)
    elsif Blahaj::CLI["words"]
      handle_argf(false, false, false, false, true)
    else
      handle_argf(false, false, false, false, false)
    end
  {% end %}
end
