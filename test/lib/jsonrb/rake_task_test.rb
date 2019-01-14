# frozen_string_literal: true

require 'test_helper'

module JSONRB
  class RakeTaskTest < Minitest::Test
    module RakeMocks
      class << self
        attr_accessor :description
        attr_accessor :task
      end

      def desc(description)
        RakeMocks.description = description
      end

      def task(name, &block)
        RakeMocks.task = { name: name, block: block }
      end
    end

    JSONRB::RakeTask.include(RakeMocks)

    def teardown
      File.delete(output_file) if File.exists?(output_file)
    end

    def test_config_block
      task = JSONRB::RakeTask.new(:build_template) do |t|
        t.output_file = TEMP_PATH.join('template.json')
        t.template_name = :resources
        t.template_path = fixture_path('merge_test')
      end

      assert_equal output_file, task.output_file
      assert_equal template_path, task.template_path
    end

    def test_config_options
      assert_equal :build_template, rake_task.name
      assert_equal output_file, rake_task.output_file
      assert_equal template_path, rake_task.template_path
    end

    def test_invalid_output_file
      error = assert_raises(ArgumentError) do
        JSONRB::RakeTask.new(:build_template, valid_options.merge(output_file: nil))
      end

      assert_equal 'output_file cannot be blank', error.message
    end

    def test_invalid_template_name
      error = assert_raises(ArgumentError) do
        JSONRB::RakeTask.new(:build_template, valid_options.merge(template_name: nil))
      end

      assert_equal 'template_name cannot be blank', error.message
    end

    def test_invalid_template_path
      error = assert_raises(ArgumentError) do
        JSONRB::RakeTask.new(:build_template, valid_options.merge(template_path: 'invalid'))
      end

      assert_equal 'invalid template_path: "invalid"', error.message
    end

    def test_define
      RakeMocks.description = nil
      RakeMocks.task = nil
      
      rake_task

      assert_equal JSONRB::RakeTask::DESCRIPTION, RakeMocks.description
      assert_equal :build_template, RakeMocks.task[:name]
      assert_kind_of Proc, RakeMocks.task[:block]
    end

    def test_execute
      refute File.exists?(output_file)
      rake_task.execute
      assert File.exists?(output_file)

      exp = '{"resources":{"resource_a":{"name":"Resource A"},"resource_b":{"name":"Resource B"}}}'
      assert_equal exp, File.read(output_file)
    end

    private

    # @return [Pathname]
    def output_file
      @output_file ||= TEMP_PATH.join('template.json')
    end

    # @return [Pathname]
    def template_path
      @template_path ||= fixture_path('merge_test')
    end

    # @return [JSONRB::RakeTask]
    def rake_task
      @rake_task ||= JSONRB::RakeTask.new(:build_template, valid_options)
    end

    def valid_options
      @valid_options ||= {
        output_file: output_file,
        template_name: :resources,
        template_path: template_path,
      }
    end
  end
end
