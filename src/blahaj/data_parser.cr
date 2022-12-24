module Blahaj
  class Flags
    getter flags : Hash(String, Flag)

    class Flag
      include YAML::Serializable

      property color : Array(Blahaj::Color)

      @[YAML::Field(key: "alias")] # alias is reserved
      property aliases : Array(String) = [] of String
    end

    def initialize(yaml_data : String)
      @flags = Hash(String, Flag).from_yaml(yaml_data)
    end
  end
end
