# frozen_string_literal: true

require 'test_helper'

module JSONRB
  class ErrorTest < Minitest::Test
    def test_standard_error
      assert_includes JSONRB::Error.ancestors, StandardError
    end
  end
end
