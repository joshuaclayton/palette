module Palette
  class Rule
    attr_reader :name, :fg, :bg, :gui

    def initialize(name, *args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      @name = name.to_s
      @fg   = options[:fg]  || args.first
      @bg   = options[:bg]  || (args.length > 1 ? args.last : nil)
      @gui  = options[:gui]
    end

    def to_s
      return "" if fg.nil? && bg.nil? && gui.nil?
      output = ["hi", name]

      if fg
        color = Palette::Color.new(fg)
        output << %{guifg=##{color.to_hex}}
        output << %{ctermfg=#{color.to_cterm}}
      end

      if bg
        color = Palette::Color.new(bg)
        output << %{guibg=##{color.to_hex}}
        output << %{ctermbg=#{color.to_cterm}}
      end

      if gui
        output << %{gui=#{gui}}
        if gui !~ /italic/
          output << %{cterm=#{gui}}
        end
      end

      output.join(" ")
    end
  end
end
