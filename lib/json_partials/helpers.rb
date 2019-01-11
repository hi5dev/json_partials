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

    # Renders the template partial at the given path.
    #
    # @param [String] partial_path Path relative to the path given when initializing the Document.
    # @return [Array | Hash]
    def render(partial_path)
      full_path = path.join(partial_path).to_s

      full_path = "#{full_path}.rb" if File.extname(path).empty?

      code = File.read(full_path)

      result = eval(code, binding, full_path.to_s)

      @output = validate!(result)
    end
  end
end
