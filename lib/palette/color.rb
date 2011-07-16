module Palette
  class Color
    BASE_SET = [0, 95, 135, 175, 215, 255]
    GRAY_SET = [  8,  18,  28,  38,  48,  58,  68,  78,  88,  98, 108, 118,
                128, 138, 148, 158, 168, 178, 188, 198, 208, 218, 228, 238]

    def initialize(value)
      @hex = self.class.parse(value)
    end

    def to_hex
      @hex
    end

    def to_cterm
      self.class.color_map.key(closest_cterm_hex)
    end

    private

    def self.parse(hex)
      if hex.upcase =~ /^[A-F\d]{3}$/
        hex.split(//).map {|code| code * 2 }.join
      elsif hex.upcase =~ /^[A-F\d]{6}$/
        hex
      else
        raise "invalid hex value: #{hex}"
      end.upcase
    end

    def closest_cterm_hex
      all_colors = self.class.color_map.values.map do |hexcode|
        original_r, original_g, original_b = self.class.hex_to_decimal(@hex)
        r, g, b = self.class.hex_to_decimal(hexcode)
        distance = (original_r - r).abs + (original_g - g).abs + (original_b - b).abs
        [hexcode, distance]
      end
      Hash[*all_colors.flatten].min {|a, b| a[1] <=> b[1] }[0]
    end

    def self.color_map
      @colors = {}
      counter = 16
      (0...6).each do |red|
        (0...6).each do |green|
          (0...6).each do |blue|
            @colors[counter] = [
              decimal_to_hex(BASE_SET[red]),
              decimal_to_hex(BASE_SET[green]),
              decimal_to_hex(BASE_SET[blue])
            ].join
            counter += 1
          end
        end
      end

      GRAY_SET.each do |scale|
        @colors[counter] = decimal_to_hex(scale) * 3
        counter += 1
      end
      @colors
    end

    def self.decimal_to_hex(decimal)
      base = ("%x" % decimal).strip
      base = "0#{base}" if base.length == 1
      base
    end

    def self.hex_to_decimal(hex)
      hex.scan(/../).map {|x| ("%2d" % "0x#{x}").to_i }
    end
  end
end
