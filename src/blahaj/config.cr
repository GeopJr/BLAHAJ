module Blahaj
  class Config
    INSTANCE = Config.new

    property background : Bool = false
    property flag : Bool = false
    property shark : Bool = false
    property individual : Bool = false
    property words : Bool = false
    property multiplier : Int32 = 1
    property color : String = "trans"

    def initialize
    end
  end

  def self.config(&)
    yield Config::INSTANCE
  end

  def self.config
    Config::INSTANCE
  end
end
