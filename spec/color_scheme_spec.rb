require "spec_helper"

describe Palette::ColorScheme do
  let(:color_name) { "great" }
  subject          { Palette::ColorScheme.new(color_name) }

  it "accepts a name as a constructor argument" do
    subject.name.should == color_name
    subject.to_s.should include(%{let colors_name="#{color_name}"})
  end
end

describe Palette::ColorScheme, "notes" do
  subject { Palette::ColorScheme.new("abc") }

  it "allows assignment of author" do
    subject.notes "Based on something great"
    subject.to_s.should =~ /".*Based on something great/
  end
end

describe Palette::ColorScheme, "author" do
  subject { Palette::ColorScheme.new("abc") }

  it "allows assignment of author" do
    subject.author "John Doe"
    subject.to_s.should include(%{" Author: John Doe})
  end
end

describe Palette::ColorScheme, "reset" do
  subject { Palette::ColorScheme.new("abc") }

  let(:header) do
    %{
hi clear
if version > 580
    if exists("syntax_on")
        syntax reset
    endif
endif
    }.strip
  end

  it "generates a reset when set" do
    subject.reset(true)
    subject.to_s.should include(header)
  end

  it "doesn't include a reset by default" do
    subject.to_s.should_not include(header)
  end
end

describe Palette::ColorScheme, "background" do
  subject { Palette::ColorScheme.new("abc") }

  it "generates a light background when set" do
    background = %{
if has("gui_running")
    set background=light
endif
    }.strip
    subject.background(:light)
    subject.to_s.should include(background)
  end

  it "generates a dark background when set" do
    background = %{
if has("gui_running")
    set background=dark
endif
    }.strip
    subject.background(:dark)
    subject.to_s.should include(background)
  end

  it "doesn't create a background by default" do
    subject.to_s.should_not include("set background")
  end

  it "doesn't create a background if bad data is passed" do
    subject.background("lame")
    subject.to_s.should_not include("set background")
  end
end

describe Palette::ColorScheme, "rule generation" do
  before { Palette::Rule.stubs(:new => "Custom rule") }

  it "creates simple rules" do
    Palette::ColorScheme.run "one", lambda {
      Comment "ABCDEF", :gui => "bold"
    }
    Palette::Rule.should have_received(:new).with("Comment", "ABCDEF", :gui => "bold")
  end

  it "creates multiple rules" do
    Palette::ColorScheme.run "one", lambda {
      Comment "ABCDEF", :gui => "bold"
      Regexp  :gui => "bold"
    }
    Palette::Rule.should have_received(:new).with("Comment", "ABCDEF", :gui => "bold")
    Palette::Rule.should have_received(:new).with("Regexp", :gui => "bold")
  end

  it "handles Ruby naming conflicts" do
    Palette::ColorScheme.run "one", lambda {
      String "ABCDEF"
    }
    Palette::Rule.should have_received(:new).with("String", "ABCDEF")
  end

  it "outputs rules" do
    output = Palette::ColorScheme.run "one", lambda {
      Comment "ABCDEF", :gui => "bold"
      String "ABCDEF"
    }

    output.should include(%{Custom rule\nCustom rule})
  end
end

describe Palette::ColorScheme, "linking" do
  before { Palette::Link.stubs(:new => "Custom link") }

  it "handles simple linking" do
    Palette::ColorScheme.run "one", lambda {
      link :Something, :to => :Another
    }
    Palette::Link.should have_received(:new).with(:Something, :Another)
  end

  it "handles complex linking" do
    Palette::ColorScheme.run "one", lambda {
      link :Something, :Else, :to => :Another
      link :Red, :to => :Black
    }
    Palette::Link.should have_received(:new).with(:Something, :Another)
    Palette::Link.should have_received(:new).with(:Else, :Another)
    Palette::Link.should have_received(:new).with(:Red, :Black)
  end

  it "outputs links" do
    output = Palette::ColorScheme.run "one", lambda {
      link :Something, :Else, :to => :Another
      link :Red, :to => :Black
    }

    output.should include(%{Custom link\nCustom link\nCustom link})
  end
end

describe Palette::ColorScheme, "output order" do
  subject                 { Palette::ColorScheme.new("abc") }
  let(:header)            { "header" }
  let(:color_scheme_name) { "color scheme name" }
  let(:reset)             { "reset" }
  let(:background)        { "background" }

  before do
    subject.stubs(:header              => header,
                  :color_scheme_name   => color_scheme_name,
                  :generate_reset      => reset,
                  :generate_background => background)
  end

  it "generates the color file in the correct order" do
    subject.to_s.should == [header, color_scheme_name, reset, background].join("\n")
  end
end

describe Palette::ColorScheme, ".run" do
  let(:color_scheme) do
    mock("color-scheme").tap do |scheme|
      scheme.stubs(:great => "things")
    end
  end

  before do
    Palette::ColorScheme.stubs(:new => color_scheme)
  end

  it "creates a new color scheme with the correct name" do
    Palette::ColorScheme.run "Great", lambda {
      great
    }
    Palette::ColorScheme.should have_received(:new).with("Great")
    color_scheme.should have_received(:great)
  end
end
