require "bundler"
Bundler::GemHelper.install_tasks

require "rspec/core/rake_task"
require "cucumber/rake/task"

RSpec::Core::RakeTask.new(:rspec)
Cucumber::Rake::Task.new(:features)

task :default => [:rspec, :features]
