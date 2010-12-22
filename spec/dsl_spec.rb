require "spec_helper"

describe Palette::Dsl do
  let(:color_name) { "great" }

  it "creates a new scheme" do
    Palette::ColorScheme.stubs(:run)
    Palette::Dsl.new.vim_colors(color_name) {}
    Palette::ColorScheme.should have_received(:run)
  end

  it "runs schemes" do
    Palette::ColorScheme.stubs(:run)
    Palette::Dsl.run do
      vim_colors("awesome") {}
    end
    Palette::ColorScheme.should have_received(:run)
  end
end
