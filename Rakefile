# encoding: utf-8

require 'rubygems'

begin
  require 'bundler/setup'
rescue LoadError => e
  abort e.message
end

require 'rake'

require 'rubygems/tasks'
Gem::Tasks.new

require 'rdoc/task'
RDoc::Task.new
task doc: :rdoc

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task default: %w(rubocop spec)
