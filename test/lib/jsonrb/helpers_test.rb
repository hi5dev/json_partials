# frozen_string_literal: true

require 'test_helper'

module JSONRB
  class HelpersTest < Minitest::Test
    include JSONRB::Helpers

    def test_merge
      one = { one: 1 }
      two = { two: 2 }
      three = { three: 3 }

      exp = { one: 1, two: 2, three: 3 }
      act = merge(one, two, three)

      assert_equal(exp, act)
    end
  end
end
