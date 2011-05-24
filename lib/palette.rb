require "bundler/setup"
Bundler.require(:default)

module Palette
  autoload :Cli,         "palette/cli"
  autoload :Color,       "palette/color"
  autoload :ColorScheme, "palette/color_scheme"
  autoload :Dsl,         "palette/dsl"
  autoload :Link,        "palette/link"
  autoload :Rule,        "palette/rule"
  autoload :Version,     "palette/version"
end
