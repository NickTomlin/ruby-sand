# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sand/version'

Gem::Specification.new do |gem|
  gem.name          = 'sand'
  gem.version       = Sand::VERSION
  gem.summary       = 'Authorization for rack-based applications'
  gem.description   = 'A ruby gem for authorization for use in sinatra/rack applications. Heavily inspired [Pundit](https://github.com/elabs/pundit)' # rubocop:disable Metrics/LineLength
  gem.license       = 'MIT'
  gem.authors       = ['Nick Tomlin']
  gem.email         = 'nick.tomlin@gmail.com'
  gem.homepage      = 'https://rubygems.org/gems/sand'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)

  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '~> 1.7'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rdoc', '~> 4.0'
  gem.add_development_dependency 'rspec', '~> 3.0'
  gem.add_development_dependency 'rubygems-tasks', '~> 0.2'
  gem.add_development_dependency 'rubocop', '~> 0.37.0'
  gem.add_development_dependency 'pry', '0.10.3'
  gem.add_development_dependency 'rack-test', '~> 0.6.3'
  gem.add_development_dependency 'sinatra', '~> 1.4.7'
  gem.add_development_dependency 'sequel', '~> 4.31'
  gem.add_development_dependency 'sqlite3'
end
