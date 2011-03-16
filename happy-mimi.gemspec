$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'happy-mimi/version'

Gem::Specification.new do |s|
  s.name        = "happy-mimi"
  s.version     = HappyMimi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ryan Briones"]
  s.email       = ["ryan.briones@brionesandco.com"]
  s.homepage    = "http://github.com/ryanbriones/happy-mimi"
  s.summary     = "A clean and simple Ruby library to the MadMimi API."
  # s.description = "TODO: Write a gem description"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "happy-mimi"

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "rspec", "~> 2.5.0"
  s.add_development_dependency "artifice", "0.6"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end