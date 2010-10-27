module Palette
  class Link
    @@max_length = 0
    attr_reader :from, :to

    def initialize(from, to)
      @from = from.to_s
      @to   = to.to_s
      @@max_length = @from.length if @from.length > @@max_length
    end

    def to_s
      %{hi link #{sprintf("%-#{@@max_length}s", self.from)} #{self.to}}
    end
  end
end
