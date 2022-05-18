require "./spec_helper"

describe Blahaj do
  it "outputs a trans flag" do
    output = {{ run("#{__DIR__}/../src/blahaj", "-f").stringify }}
    result = {{ read_file("#{__DIR__}/results/flag.txt") }}

    output.should eq result
  end

  it "outputs a trans flag with 3x multiplier" do
    output = {{ run("#{__DIR__}/../src/blahaj", "-f", "-m", "3").stringify }}
    result = {{ read_file("#{__DIR__}/results/flag_3x.txt") }}

    output.should eq result
  end

  it "outputs an agender shark" do
    output = {{ run("#{__DIR__}/../src/blahaj", "-s", "-c", "agender").stringify }}
    result = {{ read_file("#{__DIR__}/results/shark.txt") }}

    output.should eq result
  end

  it "reads from ARGF and outputs a lesbian cowsay" do
    output = {{ run("#{__DIR__}/../src/blahaj", "-c", "lesbian", "#{__DIR__}/results/cowsay.txt").stringify }}
    result = {{ read_file("#{__DIR__}/results/cowsay_colored.txt") }}

    output.should eq result
  end

  it "outputs an ace shark with each character colorized individually" do
    output = {{ run("#{__DIR__}/../src/blahaj", "-s", "-c", "ace", "-i").stringify }}
    result = {{ read_file("#{__DIR__}/results/shark_individual.txt") }}

    output.should eq result
  end

  it "outputs an aro shark with each word colorized individually" do
    output = {{ run("#{__DIR__}/../src/blahaj", "-s", "-c", "aro", "-w").stringify }}
    result = {{ read_file("#{__DIR__}/results/shark_words.txt") }}

    output.should eq result
  end

  it "outputs a gay shark with its background colorized" do
    output = {{ run("#{__DIR__}/../src/blahaj", "-s", "-c", "nwlnw", "-b").stringify }}
    result = {{ read_file("#{__DIR__}/results/shark_background.txt") }}

    output.should eq result
  end
end
