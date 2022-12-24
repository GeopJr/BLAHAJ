module Blahaj
  class Colorizer
    @io : IO
    @config : Blahaj::Config
    @scheme : Array(Blahaj::Color)
    @multiplied_cols : Int32 = 1
    @iter : IO::ARGF | String
    @proc : Proc(String | Char, Blahaj::Color, Colorize::Object(Char) | Colorize::Object(String))

    def initialize(config : Blahaj::Config = Blahaj.config, io : IO = STDOUT)
      @io = io
      @config = config
      @scheme = COLORS[config.color].color

      if config.flag
        @multiplied_cols = 4 * @scheme.size * config.multiplier

        return print_flag
      end

      @proc = proc_bg_fw
      @iter = config.shark ? ASCII : ARGF
      if config.individual
        print_individual
      elsif config.words
        print_words
      elsif config.background
        print_background
      else
        print_color
      end
    end

    private def print_flag
      row = " " * @multiplied_cols
      @scheme.each do |x|
        @config.multiplier.times do
          @io.puts row.colorize.back(x.color)
        end
      end
    end

    private def print_background
      @iter.each_line.with_index do |x, i|
        @io.puts @proc.call(x, current_color(i))
      end
    end

    private def print_individual
      i = 0

      @iter.each_char do |x|
        next @io.print x if NO_COLOR.includes?(x)
        c_color = current_color(i)
        i = i.succ

        @io.print @proc.call(x, c_color)
      end
    end

    private def print_words
      c_color = current_color(0)
      dont_change = false
      i = 0

      @iter.each_char do |x|
        if NO_COLOR.includes?(x)
          unless dont_change
            c_color = current_color(i)
            i = i.succ
          end
          dont_change = true

          next @io.print x
        end
        dont_change = false

        @io.print @proc.call(x, c_color)
      end
    end

    private def print_color
      @iter.each_line.with_index do |x, i|
        @io.puts @proc.call(x, current_color(i))
      end
    end

    private def proc_bg_fw(flag : Bool = false) : Proc(String | Char, Blahaj::Color, Colorize::Object(Char) | Colorize::Object(String))
      if @config.background
        ->(x : String | Char, c_color : Blahaj::Color) { x.colorize.back(c_color.color).fore(c_color.foreground) }
      else
        ->(x : String | Char, c_color : Blahaj::Color) { x.colorize(c_color.color) }
      end
    end

    private def current_color(index : Int32) : Blahaj::Color
      @scheme[index % @scheme.size]
    end
  end
end
