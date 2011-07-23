require "spec_helper"

describe Palette::Color, "color conversion" do
  it "generates hex from three hex digits" do
    Palette::Color.new("AAA").to_hex.should == "#AAAAAA"
  end

  it "generates hex from six hex digits" do
    Palette::Color.new("FAFAFA").to_hex.should == "#FAFAFA"
  end

  it "generates cterm colors from three hex digits" do
    Palette::Color.new("000").to_cterm.should == 16
  end

  it "generates cterm colors from six hex digits" do
    Palette::Color.new("eeeeee").to_cterm.should == 255
  end

  it "generates the closest cterm colors to a hex value" do
    Palette::Color.new("eeeeef").to_cterm.should == 255
    Palette::Color.new("d7005f").to_cterm.should == 161
    Palette::Color.new("fffffa").to_cterm.should == 231
  end

  it "returns NONE when color is none" do
    Palette::Color.new("none").to_hex.should   == "NONE"
    Palette::Color.new("none").to_cterm.should == "NONE"
  end

  it "raises an error if a bad color is passed" do
    expect { Palette::Color.new("abcdfg") }.to raise_error
    expect { Palette::Color.new("abcdf") }.to raise_error
    expect { Palette::Color.new("00ff") }.to raise_error
    expect { Palette::Color.new("0f") }.to raise_error
  end

end
