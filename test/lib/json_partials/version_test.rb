# frozen_string_literal: true

require 'test_helper'

module JsonPartials
  class VersionTest < Minitest::Test
    def test_semantic
      assert_match /^(\d+\.)?(\d+\.)?(\*|\d+)$/, JsonPartials::VERSION
    end
  end
end
