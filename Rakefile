require "bundler/gem_tasks"

require "rake/testtask"

Rake::TestTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

desc "Run tests"
task default: :test
