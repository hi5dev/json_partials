# frozen_string_literal: true

ROOT_PATH = File.expand_path(__dir__)

# Add the lib folder to the Ruby load path.
($LOAD_PATH << File.join(ROOT_PATH, 'lib')).uniq!

require 'jsonrb/version'

Gem::Specification.new do |spec|
  spec.name = 'jsonrb'
  spec.version = JSONRB::VERSION
  spec.authors = ['Travis Haynes']
  spec.email = ['travis@hi5dev.com']
  spec.licenses = ['Apache-2.0']

  spec.summary = 'Build JSON from multiple Ruby sources that output a Hash or Array.'
  spec.homepage = 'https://github.com/hi5dev/jsonrb'

  spec.require_paths = ['lib']

  spec.files = Dir[File.join(ROOT_PATH, 'lib', '**', '*.rb')].map do |file|
    file[ROOT_PATH.length + 1..-1]
  end

  spec.files << 'Gemfile'
  spec.files << 'Gemfile.lock'
  spec.files << 'jsonrb.gemspec'
  spec.files << 'LICENSE'
  spec.files << 'README.md'

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'debase', '~> 0.2'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'ruby-debug-ide', '~> 0.6'
  spec.add_development_dependency 'yard', '~> 0.9'
end
