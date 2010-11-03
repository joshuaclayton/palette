require "palette"
module Palette
  class Cli
    def initialize(*args)
      if File.exist?(path = File.expand_path(args.first))
        puts Palette::Dsl.run lambda {
          eval(IO.read(path), binding, path)
        }
      end
    end
  end
end
