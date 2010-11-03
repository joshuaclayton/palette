require "spec"
require "mocha"
require "palette"
require "bourne"

Spec::Runner.configure do |config|
  config.mock_with :mocha

  Mocha::Configuration.warn_when(:stubbing_non_existant_method)
  Mocha::Configuration.warn_when(:stubbing_non_public_method)
end
