require "spec_helper"

shared_examples_for "rule with colors" do
  let(:fg)    { "DEF" }
  let(:bg)    { "ABC" }
  let(:hex)   { "ABCDEF" }
  let(:cterm) { 123 }
  let(:color) do
    mock("color").tap do |color|
      color.stubs(:to_hex => "##{hex}", :to_cterm => cterm)
    end
  end

  before { Palette::Color.stubs(:new => color) }
end

describe Palette::Rule, "with a foreground" do
  it_should_behave_like "rule with colors" do
    subject { Palette::Rule.new("Awesome", fg) }

    it "highlights the correct colors" do
      subject.to_s.should == "hi Awesome guifg=##{hex} ctermfg=#{cterm}  gui=NONE cterm=NONE"
    end

    it "converts the correct colors" do
      subject.to_s
      Palette::Color.should have_received(:new).with(fg)
      Palette::Color.should_not have_received(:new).with(bg)
    end
  end
end

describe Palette::Rule, "with a foreground set to none" do
  subject { Palette::Rule.new("Awesome", "none") }

  it "highlights the correct colors" do
    subject.to_s.should == "hi Awesome guifg=NONE    ctermfg=NONE gui=NONE cterm=NONE"
  end
end

describe Palette::Rule, "with a foreground and background" do
  it_should_behave_like "rule with colors" do
    subject { Palette::Rule.new("Awesome", fg, bg) }

    it "highlights the correct colors" do
      subject.to_s.should == "hi Awesome guifg=##{hex} ctermfg=#{cterm}  guibg=##{hex} ctermbg=#{cterm}  gui=NONE cterm=NONE"
    end

    it "converts the correct colors" do
      subject.to_s
      Palette::Color.should have_received(:new).with(fg)
      Palette::Color.should have_received(:new).with(bg)
    end
  end
end

describe Palette::Rule, "with a hash passed" do
  it_should_behave_like "rule with colors" do
    subject { Palette::Rule.new("Awesome", :fg => fg, :bg => bg) }

    it "highlights the correct colors" do
      subject.to_s.should == "hi Awesome guifg=##{hex} ctermfg=#{cterm}  guibg=##{hex} ctermbg=#{cterm}  gui=NONE cterm=NONE"
    end

    it "converts the correct colors" do
      subject.to_s
      Palette::Color.should have_received(:new).with(fg)
      Palette::Color.should have_received(:new).with(bg)
    end
  end
end

describe Palette::Rule, "with a gui" do
  subject { Palette::Rule.new("Awesome", :gui => "bold") }

  it "sets the gui correctly" do
    subject.to_s.should == "hi Awesome gui=BOLD cterm=BOLD"
  end
end

describe Palette::Rule, "with a gui as italic" do
  subject { Palette::Rule.new("Awesome", :gui => "italic") }

  it "sets the gui correctly" do
    subject.to_s.should == "hi Awesome gui=ITALIC cterm=NONE"
  end
end

describe Palette::Rule, "without colors" do
  subject { Palette::Rule.new("Awesome") }

  it "is empty" do
    subject.to_s.should == ""
  end
end
