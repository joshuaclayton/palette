require "spec_helper"

describe Palette::Link do
  it "creates a link from one rule to another" do
    Palette::Link.new("one", "two").to_s.should == %{hi link one two}
  end

  it "uses the longest 'from' as a base length" do
    Palette::Link.new("three", "four")
    Palette::Link.new("one",   "two").to_s.should == %{hi link one   two}
  end
end
