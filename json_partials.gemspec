# frozen_string_literal: true

# Add the lib folder to the Ruby load path.
($LOAD_PATH << File.expand_path('lib', __dir__)).uniq!

require 'json_partials/version'

Gem::Specification.new do |spec|
  spec.name = 'json_partials'
  spec.version = JsonPartials::VERSION
  spec.authors = ['Travis Haynes']
  spec.email = ['travis@hi5dev.com']

  spec.summary = 'Build JSON from multiple Ruby sources that output a Hash or Array.'
  spec.homepage = 'https://github.com/hi5dev/json_partials'

  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'debase', '~> 0.2'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'ruby-debug-ide', '~> 0.6'
  spec.add_development_dependency 'yard', '~> 0.9'
end
