module Palette
  class Dsl
    def self.run(block)
      new.instance_eval(&block)
    end

    def vim_colors(color_name, &block)
      Palette::ColorScheme.run(color_name, block)
    end
  end
end
