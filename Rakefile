require 'rubygems'
require 'bundler/gem_tasks'

require 'rake'
require 'rspec/core/rake_task'

desc "Run RSpec"
task :default => :spec
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/*_spec.rb" 
end

namespace :lint do

  desc 'remove tailing whitespace'
  task :notail do
    Dir.glob(File.join Dir.pwd, '*.rb').each do |fyl|
      %x{sed -i 's/\ *$//g' #{fyl}}
    end
    Dir.glob(File.join Dir.pwd, '*', '*.rb').each do |fyl|
      %x{sed -i 's/\ *$//g' #{fyl}}
    end
    Dir.glob(File.join Dir.pwd, '*', '*', '*.rb').each do |fyl|
      %x{sed -i 's/\ *$//g' #{fyl}}
    end
  end
end
