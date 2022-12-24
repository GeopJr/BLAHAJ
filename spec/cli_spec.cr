require "./spec_helper"

def to_cli_args(arr)
  arr.map do |k, v|
    next if v == false

    prefix = "-"
    joiner = ""
    if k.to_s.size > 1
      prefix += prefix
      joiner = "="
    end

    flag = "#{prefix}#{k}"

    if v.is_a?(Bool)
      flag
    else
      "#{flag}#{joiner}#{v}"
    end
  end.compact
end

describe Blahaj::CLI do
  r = Random.new

  it "sets the config" do
    args = {
      b: r.next_bool,
      s: r.next_bool,
      f: r.next_bool,
      i: r.next_bool,
      w: r.next_bool,
      m: r.rand(100) + 1,
      c: Blahaj::COLORS.keys.sample,
    }

    cli = Blahaj::CLI.new(to_cli_args(args))
    cli.config.background.should eq args[:b]
    cli.config.shark.should eq args[:s]
    cli.config.flag.should eq args[:f]
    cli.config.individual.should eq args[:i]
    cli.config.words.should eq args[:w]
    cli.config.multiplier.should eq args[:m]
    cli.config.color.should eq args[:c]
  end

  it "gets the flag from alias" do
    original_flag = Blahaj::COLORS.reject { |k, v| v.aliases.size == 0 }.sample
    args = {
      c: original_flag[1].aliases.sample,
    }

    cli = Blahaj::CLI.new(to_cli_args(args))
    cli.config.color.should eq original_flag[0]
  end

  it "handles multiplier limits" do
    args = {
      m: 0,
    }

    cli = Blahaj::CLI.new(to_cli_args(args))
    cli.config.multiplier.should_not eq args[:m]
  end
end
