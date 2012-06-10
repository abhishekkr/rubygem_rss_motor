require 'rubygems'
require 'bundler/gem_tasks'

require 'rake'
require 'rspec/core/rake_task'

desc "Run RSpec"
task :default => :spec
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/*_spec.rb" 
end