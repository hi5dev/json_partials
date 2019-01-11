# frozen_string_literal: true

module JsonPartials
  module Helpers
    # Merges multiple hashes together.
    #
    # @example
    #   one = { one: 1 }
    #   two = { two: 2 }
    #   three = { three: 3 }
    #   merge(one, two, three) # => { one: 1, two: 2, three: 3 }
    #
    # @param [*Hash] hashes All of the hashes to merge.
    # @return [Hash] Merged hashes.
    def merge(*hashes)
      hashes.inject({}, &:merge!)
    end
  end
end
