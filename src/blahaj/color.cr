require "colorize"

# Removes '#' prefix (if any) and
# transforms 3 character hex colors
# to 6 character ones.
def clean_hex(hex : String) : String
  clean_hex = hex.lstrip('#')

  if clean_hex.size == 3
    clean_hex = String.build do |str|
      clean_hex.each_char do |char|
        str << char
        str << char
      end
    end
  end

  clean_hex.upcase
end

# Converts rgb to hex.
def rgb2hex(r : UInt8, g : UInt8, b : UInt8) : String
  "#{r.to_s(16).rjust(2, '0')}#{g.to_s(16).rjust(2, '0')}#{b.to_s(16).rjust(2, '0')}"
end

# Converts hex to rgb.
def hex2rgb(hex : String) : NamedTuple(r: UInt8, g: UInt8, b: UInt8)
  chars = clean_hex(hex).chars.each

  {
    r: "#{chars.next}#{chars.next}".to_u8(16),
    g: "#{chars.next}#{chars.next}".to_u8(16),
    b: "#{chars.next}#{chars.next}".to_u8(16),
  }
end

module Blahaj
  class Color
    getter r, g, b : UInt8
    getter color : Colorize::ColorRGB

    # Initialize `Blahaj::Color` using UInt8 RGB values
    def initialize(r : UInt8, g : UInt8, b : UInt8)
      @r = r
      @g = g
      @b = b
      @hex = "##{rgb2hex(@r, @g, @b)}"
      @color = Colorize::ColorRGB.new(@r, @g, @b)
    end

    # Initialize `Blahaj::Color` using Int32 RGB values
    def initialize(r : Int32, g : Int32, b : Int32)
      @r = r.to_u8
      @g = g.to_u8
      @b = b.to_u8
      @hex = "##{rgb2hex(@r, @g, @b)}"
      @color = Colorize::ColorRGB.new(@r, @g, @b)
    end

    # Initialize `Blahaj::Color` using hex string
    def initialize(hex : String)
      rgb = hex2rgb(hex)
      @r = rgb[:r]
      @g = rgb[:g]
      @b = rgb[:b]
      @hex = "##{clean_hex(hex)}"
      @color = Colorize::ColorRGB.new(@r, @g, @b)
    end

    # :nodoc:
    def initialize(json : JSON::PullParser)
      initialize(json.read_string)
    end

    # :nodoc:
    def initialize(ctx : YAML::ParseContext, node : YAML::Nodes::Node)
      unless node.is_a?(YAML::Nodes::Scalar)
        node.raise "Expected scalar, not #{node.kind}"
      end

      initialize(node.value)
    end

    # Hex string
    def hex : String
      @hex.upcase
    end

    # Returns the foreground color based on whether the color is dark or light
    def foreground : Colorize::ColorRGB
      ((0.299 * @r + 0.587 * @g + 0.114 * @b)/255) > 0.5 ? Colorize::ColorRGB.new(0, 0, 0) : Colorize::ColorRGB.new(255, 255, 255)
    end
  end
end
