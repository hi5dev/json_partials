# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'

module JSONRB
  class RakeTask
    attr_reader :name
    attr_accessor :default_file_ext, :description, :output_file, :pretty, :template_name, :template_path

    DESCRIPTION = 'Builds JSON template'

    # @yieldparam [JSONRB::RakeTask] config
    def initialize(name, options = {})
      @name = name

      @default_file_ext = options.fetch(:default_file_ext, '.json.rb')
      @description = options.fetch(:description, DESCRIPTION)
      @output_file = options.fetch(:output_file, nil)
      @pretty = options.fetch(:pretty, false)
      @template_name = options.fetch(:template_name, nil)
      @template_path = options.fetch(:template_path, nil)

      yield(self) if block_given?

      raise ArgumentError, "invalid template_path: #{template_path.inspect}" unless File.directory?(template_path)
      raise ArgumentError, 'template_name cannot be blank' if template_name.nil? || template_name.empty?
      raise ArgumentError, 'output_file cannot be blank' if output_file.nil? || output_file.empty?

      define
    end

    def define
      desc(description)
      task(name, &method(:execute))
    end

    def execute
      document = JSONRB::Document.new(template_path, default_file_ext: default_file_ext, pretty: pretty)
      document.render(*Array(template_name))
      document.save(output_file)
    end
  end
end
