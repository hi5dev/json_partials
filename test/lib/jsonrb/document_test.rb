# frozen_string_literal: true

require 'test_helper'

module JSONRB
  class DocumentTest < Minitest::Test
    def teardown
      File.delete(resource_path) if File.exists?(resource_path)
    end

    def test_full_path
      exp = fixture_path('merge_test', 'resources', 'a.json.rb')

      assert_equal exp, document.full_path(:resources, :a)
      assert_equal exp, document.full_path(:resources, 'a.json.rb')

      document.default_file_ext = 'json.rb'
      assert_equal exp, document.full_path(:resources, :a)
      assert_equal exp, document.full_path(:resources, 'a.')

      exp = fixture_path('merge_test', 'resources', 'a')

      document.default_file_ext = ''
      assert_equal exp, document.full_path(:resources, :a)

      document.default_file_ext = false
      assert_equal exp, document.full_path(:resources, :a)

      document.default_file_ext = nil
      assert_equal exp, document.full_path(:resources, :a)
    end

    def test_merge
      assert_equal resources_output, document.render('resources')
    end

    def test_pretty
      document.pretty = true
      refute File.exists?(resource_path)
      document.render('resources')
      document.save(resource_path)
      assert File.exists?(resource_path)
      assert_equal JSON.pretty_generate(resources_output), File.read(resource_path)
    end

    def test_save
      refute File.exists?(resource_path)
      document.render('resources')
      document.save(resource_path)
      assert File.exists?(resource_path)
      assert_equal resources_output.to_json, File.read(resource_path)
    end

    private

    # @return [JSONRB::Document]
    def document
      @document ||= JSONRB::Document.new(templates_path)
    end

    # @return [Hash]
    def resources_output
      @expected_output ||= {
        resources: {
          resource_a: {
            name: 'Resource A'
          },
          resource_b: {
            name: 'Resource B'
          }
        }
      }
    end

    # @return [Pathname]
    def resource_path
      @resource_path ||= TEMP_PATH.join('resources.json')
    end

    # @return [Pathname]
    def templates_path
      @templates_path ||= fixture_path('merge_test')
    end
  end
end
