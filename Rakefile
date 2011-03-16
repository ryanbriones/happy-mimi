require 'rspec/core/rake_task'
require 'rake/gempackagetask'

HAPPY_MIMI_SPEC = begin
  file = File.expand_path(File.dirname(__FILE__) + '/happy-mimi.gemspec')
  eval(File.read(file), binding, file)
end

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
end
task :default => "rake:spec"

Rake::GemPackageTask.new(HAPPY_MIMI_SPEC) {}