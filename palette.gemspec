# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "palette/version"

Gem::Specification.new do |s|
  s.name        = "palette"
  s.version     = Palette::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Josh Clayton"]
  s.email       = ["joshua.clayton@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/palette"
  s.summary     = %q{Build Vim colorschemes with ease}
  s.description = %q{Palette provides an easy way to build Vim color schemes}

  s.rubyforge_project = "palette"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
