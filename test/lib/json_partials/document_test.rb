# frozen_string_literal: true

require 'test_helper'

module JsonPartials
  class DocumentTest < Minitest::Test
    def setup
      @pretty = false
    end

    def teardown
      File.delete(resource_path) if File.exists?(resource_path)
    end

    def test_merge
      assert_equal resources_output, document.render('resources')
    end

    def test_save
      refute File.exists?(resource_path)
      document.render('resources')
      document.save(resource_path)
      assert File.exists?(resource_path)
      assert_equal resources_output.to_json, File.read(resource_path)
    end

    def test_pretty
      @pretty = true

      refute File.exists?(resource_path)
      document.render('resources')
      document.save(resource_path)
      assert File.exists?(resource_path)
      assert_equal JSON.pretty_generate(resources_output), File.read(resource_path)
    end

    private

    # @return [JsonPartials::Document]
    def document
      @document ||= JsonPartials::Document.new(fixture_path('merge_test'), pretty: @pretty)
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
  end
end
