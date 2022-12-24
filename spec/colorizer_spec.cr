require "./spec_helper"

describe Blahaj::Colorizer do
  it "outputs a trans flag" do
    config = Blahaj::Config.new
    config.flag = true

    io = IO::Memory.new
    colorizer = Blahaj::Colorizer.new(config, io)

    io.to_s.should eq {{ read_file("#{__DIR__}/results/flag.txt") }}
  end

  it "outputs a trans flag with 3x multiplier" do
    config = Blahaj::Config.new
    config.flag = true
    config.multiplier = 3

    io = IO::Memory.new
    colorizer = Blahaj::Colorizer.new(config, io)

    io.to_s.should eq {{ read_file("#{__DIR__}/results/flag_3x.txt") }}
  end

  it "outputs an agender shark" do
    config = Blahaj::Config.new
    config.shark = true
    config.color = "agender"

    io = IO::Memory.new
    colorizer = Blahaj::Colorizer.new(config, io)

    io.to_s.should eq {{ read_file("#{__DIR__}/results/shark.txt") }}
  end

  it "reads from ARGF and outputs a lesbian cowsay" do
    ARGV << "#{__DIR__}/results/cowsay.txt"

    config = Blahaj::Config.new
    config.color = "lesbian"

    io = IO::Memory.new
    colorizer = Blahaj::Colorizer.new(config, io)

    io.to_s.should eq {{ read_file("#{__DIR__}/results/cowsay_colored.txt") }}
  end

  it "outputs an ace shark with each character colorized individually" do
    config = Blahaj::Config.new
    config.shark = true
    config.individual = true
    config.color = "ace"

    io = IO::Memory.new
    colorizer = Blahaj::Colorizer.new(config, io)

    io.to_s.should eq {{ read_file("#{__DIR__}/results/shark_individual.txt") }}
  end

  it "outputs an aro shark with each word colorized individually" do
    config = Blahaj::Config.new
    config.shark = true
    config.words = true
    config.color = "aro"

    io = IO::Memory.new
    colorizer = Blahaj::Colorizer.new(config, io)

    io.to_s.should eq {{ read_file("#{__DIR__}/results/shark_words.txt") }}
  end

  it "outputs a gay shark with its background colorized" do
    config = Blahaj::Config.new
    config.shark = true
    config.background = true
    config.color = "gay"

    io = IO::Memory.new
    colorizer = Blahaj::Colorizer.new(config, io)

    io.to_s.should eq {{ read_file("#{__DIR__}/results/shark_background.txt") }}
  end
end
