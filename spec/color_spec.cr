require "./spec_helper"

describe Blahaj::Color do
  it "converts hex to rgb" do
    color = Blahaj::Color.new("#FFF275")

    color.r.should eq 255
    color.g.should eq 242
    color.b.should eq 117
  end

  it "converts hex to rgb (short)" do
    color = Blahaj::Color.new("#C8A")

    color.r.should eq 204
    color.g.should eq 136
    color.b.should eq 170
  end

  it "converts rgb to hex" do
    color = Blahaj::Color.new(255, 242, 117)

    color.hex.should eq "#FFF275"
  end

  it "converts short hex to hex" do
    color = Blahaj::Color.new("#C8A")

    color.hex.should eq "#CC88AA"
  end

  it "returns Colorize::ColorRGB" do
    color = Blahaj::Color.new("#FFF275")

    color.color.red.should eq 255
    color.color.green.should eq 242
    color.color.blue.should eq 117
  end

  it "returns an accessible foreground color" do
    color = Blahaj::Color.new("#000000")

    color.foreground.red.should eq 255
    color.foreground.green.should eq 255
    color.foreground.blue.should eq 255

    color = Blahaj::Color.new("#FFFFFF")

    color.foreground.red.should eq 0
    color.foreground.green.should eq 0
    color.foreground.blue.should eq 0
  end
end
