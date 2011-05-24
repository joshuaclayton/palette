module Palette
  class Cli
    def initialize(*args)
      if File.exist?(path = File.expand_path(args.first))
        begin
          puts Palette::Dsl.run {
            eval(IO.read(path), binding, path)
          }
        rescue
          p "Please check the syntax of your palette file"
          exit 1
        end
      end
    end
  end
end
