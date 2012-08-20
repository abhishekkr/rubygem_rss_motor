# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rss-motor/version"

Gem::Specification.new do |s|
  s.name        = "rss-motor"
  s.version     = Rss::Motor::VERSION
  s.authors     = ["AbhishekKr"]
  s.email       = ["abhikumar163@gmail.com"]
  s.homepage    = "https://github.com/abhishekkr/rubygem_rss_motor"
  s.summary     = %q{wanna use RSS in your code easily, its here to aid}
  s.description = %q{boost up your RSS related applications with the motor available: https://github.com/abhishekkr/rubygem_rss_motor/blob/master/README}

  s.rubyforge_project = "rss-motor"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'xml-motor', '>= 0.1.5'
  s.add_development_dependency 'xml-motor', '>= 0.1.5'
end
