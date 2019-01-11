# frozen_string_literal: true

require 'test_helper'

module JsonPartials
  class ErrorTest < Minitest::Test
    def test_standard_error
      assert_includes JsonPartials::Error.ancestors, StandardError
    end
  end
end
