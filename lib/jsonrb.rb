# frozen_string_literal: true

require 'json'
require 'pathname'

module JSONRB
  autoload :Document, 'jsonrb/document'
  autoload :Error, 'jsonrb/error'
  autoload :Helpers, 'jsonrb/helpers'
  autoload :RakeTask, 'jsonrb/rake_task'
  autoload :VERSION, 'jsonrb/version'
end
