# frozen_string_literal: true

module JsonPartials
  # Creates a new JSON document from Ruby files in a given path.
  #
  # @!attribute path
  #   @return [Pathname] The full path to the template files.
  class Document
    include JsonPartials::Helpers

    attr_reader :output, :path, :pretty

    # @param [String] path Full path to the templates.
    # @param [true | false] pretty When +true+ the document will be formatted to be easy to read.
    # @return [JsonPartials::Document]
    def initialize(path, pretty: false)
      @output = {}
      @path = Pathname.new(path)
      @pretty = pretty
    end

    # Saves the document.
    #
    # @param [Pathname | String] full_path
    # @return [String]
    def save(full_path)
      json = pretty ? JSON.pretty_generate(output) : output.to_json

      File.write(full_path, json)
    end

    private

    # @param [Object] result
    # @raise [JsonPartials::Error] If the result from the evaluated partial is invalid.
    def validate!(result)
      return result if result.is_a?(Array) || result.is_a?(Hash)

      error = JsonPartials::Error.new('partial must output an Array or Hash')

      error.set_backtrace([full_path.to_s])

      raise(error)
    end
  end
end
