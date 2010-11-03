require 'bundler'
Bundler::GemHelper.install_tasks

Bundler.require

require "spec/rake/spectask"
require "cucumber/rake/task"

Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*.rb']
end

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = "features --format pretty"
end

task :default => [:spec, :features]
