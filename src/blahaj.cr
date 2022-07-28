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
  macro handle_input(background, flag, ascii, individual, words)
    {%
      input = if flag
                "scheme.each".id
              elsif ascii
                "ascii.each_line".id
              else
                "ARGF.each_line".id
              end
    %}

    {{input}} do |x|
      current_color = scheme[i % scheme.size]

      {% if flag %} # When -f is present
        tmp_i = 0
        # Attempt to scale the flag based on the multiplied (-m)
        while tmp_i < Blahaj::CLI["multiplier"].as(Int32)
          STDOUT.puts (" " * multiplied_cols).colorize.back(current_color.color)
          tmp_i += 1
        end
      {% elsif individual || words %} # When -w or -i are present
        # individual: x.chars.map
        # words: x.split(' ').map

        {%
          word_char_splitting = "x."
          word_char_joiner = ""
          if words
            word_char_splitting += "split(' ')"
            word_char_joiner = " "
          else
            word_char_splitting += "chars"
          end
          word_char_splitting = word_char_splitting.id
        %}

        STDOUT.puts {{word_char_splitting}}.map { |y|
          next y if NO_COLOR.includes?(y)
          tmp_color = current_color
          i += 1
          current_color = scheme[i % scheme.size]

          {% if background %}
            y.colorize.back(tmp_color.color).fore(tmp_color.foreground)
          {% else %}
            y.colorize(tmp_color.color)
          {% end %}

        }.join({{word_char_joiner}})
        i -= 1
      {% elsif background %} # When -b is present
        STDOUT.puts x.colorize.back(current_color.color).fore(current_color.foreground)
      {% else %}
        STDOUT.puts x.colorize(current_color.color)
      {% end %}
      i += 1
    end
    exit
  end

  # [MACRO]: Skip some repetitive if statements.
  macro i_w_none(background = false, flag = false, ascii = false)
    if Blahaj::CLI["individual"]
      handle_input(background: {{background}}, flag: {{flag}}, ascii: {{ascii}}, individual: true,  words: false)
    elsif Blahaj::CLI["words"]
      handle_input(background: {{background}}, flag: {{flag}}, ascii: {{ascii}}, individual: false, words: true)
    else
      handle_input(background: {{background}}, flag: {{flag}}, ascii: {{ascii}}, individual: false, words: false)
    end
  end

  # [MACRO]: Skip on spec
  {% unless @top_level.has_constant? "Spec" %}
    # This is repetitive but they are macros. It saves runtime checks.
    if Blahaj::CLI["shark"]
      if Blahaj::CLI["background"]
        i_w_none(background: true, flag: false, ascii: true)
      else
        i_w_none(background: false, flag: false, ascii: true)
      end
    elsif Blahaj::CLI["flag"]
      handle_input(background: false, flag: true, ascii: false, individual: false, words: false)
    elsif Blahaj::CLI["background"]
      i_w_none(background: true, flag: false, ascii: false)
    elsif Blahaj::CLI["individual"]
      handle_input(background: false, flag: false, ascii: false, individual: true, words: false)
    elsif Blahaj::CLI["words"]
      handle_input(background: false, flag: false, ascii: false, individual: false, words: true)
    else
      handle_input(background: false, flag: false, ascii: false, individual: false, words: false)
    end
  {% end %}
end
