require 'sass'

module Palette
  class ColorScheme
    attr_reader :name

    def initialize(color_name)
      @name = color_name
    end

    def author(author_name)
      @author_name = author_name
    end

    def notes(notes)
      @notes = notes
    end

    def reset(reset)
      @reset = !!reset
    end

    def background(shade)
      return unless %w(light dark).include?(shade.to_s)
      @background = shade.to_s
    end

    def method_missing(name, *args)
      @rules ||= []
      @rules << Palette::Rule.new(name.to_s, *args)
    end

    %w(darken lighten saturate desaturate).each do |sass_method|
      class_eval <<-EOM
        def #{sass_method}(hex, number)
          sass_evaluator(:#{sass_method}, hex_to_sass_color(hex), Sass::Script::Number.new(number))
        end
      EOM
    end

    %w(grayscale complement invert).each do |sass_method|
      class_eval <<-EOM
        def #{sass_method}(hex)
          sass_evaluator(:#{sass_method}, hex_to_sass_color(hex))
        end
      EOM
    end

    %w(String Float).each do |constant|
      define_method(constant) do |*args|
        @rules ||= []
        @rules << Palette::Rule.new(constant, *args)
      end
    end

    def to_s
      output = []
      output << header
      output << ""
      output << color_scheme_name
      output << ""
      output << generate_reset
      output << ""
      output << generate_background
      output << ""
      output << @rules
      output << ""
      output << @links
      output.compact.join("\n")
    end

    def link(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      @links ||= []
      args.each do |arg|
        @links << Link.new(arg, options[:to])
      end
    end

    def header
      %{
" Vim color file
"   This file was generated by Palette
"   http://rubygems.org/gems/palette
"
" Author: #{@author_name}
#{%{" Notes:  #{@notes}} if @notes}
      }.strip
    end

    def generate_reset
      return unless @reset
      %{
hi clear
if version > 580
    if exists("syntax_on")
        syntax reset
    endif
endif
      }.strip
    end

    def generate_background
      return unless @background
      %{
if has("gui_running")
    set background=#{@background}
endif
      }.strip
    end

    def color_scheme_name
      %{let colors_name="#{@name}"}
    end

    def self.run(name, block)
      instance = new(name)
      instance.instance_eval(&block)
      instance.to_s
    end

    private

    def sass_evaluator(method, *arguments)
      sass_context.send(method, *arguments).tap {|c| c.options = {}}.inspect.gsub(/#/, "")
    end

    def hex_to_sass_color(hex)
      Sass::Script::Color.new(Palette::Color.hex_to_decimal(Palette::Color.parse(hex)))
    end

    def sass_context
      @context ||= Sass::Script::Functions::EvaluationContext.new({})
    end
  end
end
