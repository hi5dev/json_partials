# frozen_string_literal: true

require 'test_helper'

module JSONRB
  class VersionTest < Minitest::Test
    def test_semantic
      assert_match /^(\d+\.)?(\d+\.)?(\*|\d+)$/, JSONRB::VERSION
    end
  end
end
