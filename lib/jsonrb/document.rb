# frozen_string_literal: true

module JSONRB
  # Creates a new JSON document from Ruby files in a given path.
  #
  # @!attribute default_file_ext
  #   The default file extension to use when none is provided to the #render. Set to +nil+, +false+, or an empty String
  #   to disable automatically adding file extensions.
  #   @return [String]
  #
  # @!attribute output
  #   The Ruby object that will be serialized to JSON. This is updated when you call #render. It is not initialized by
  #   default, and should only be modified if you can't accomplish what you need to using the #render method. For
  #   example, if you need to see what's in the document so far before you add anything else to it.
  #   @return [Object]
  #
  # @!attribute path
  #   The full path to the template files.
  #   @return [Pathname]
  #
  # @!attribute pretty
  #   When this is +true+, the generated JSON document will contain line feeds and indentation.
  #   @return [true | false]
  class Document
    include JSONRB::Helpers

    attr_accessor :default_file_ext, :pretty

    attr_reader :output, :path

    # @param [String] path Full path to the templates.
    # @param [String] default_file_ext The default file extension to use when none is provided in the template names.
    # @param [true | false] pretty When +true+ the document will be formatted to be easy to read.
    # @return [JSONRB::Document]
    def initialize(path, default_file_ext: '.json.rb', pretty: false)
      @default_file_ext = default_file_ext
      @output = {}
      @path = Pathname.new(path)
      @pretty = pretty
    end

    # Gets the full path for the template with the given name.
    #
    # @example
    #   document = JSONRB::Document.new('/usr/src/app/templates')
    #   document.full_path(:resources, :a) # => '/usr/src/app/templates/resources/a.json.rb'
    #
    # @param [*String | *Symbol] name Name of the template with or without an extension.
    # @return [String] Full path to the template.
    def full_path(*name)
      # @type [Array<String>] Pathname#join only allows Strings
      rel_path = name.map(&:to_s)

      # @type [Pathname] Expand the relative path based on the template path provided to the initializer.
      fp = path.join(*rel_path).to_s

      # No more processing required if the user provided the file extension in the name.
      return fp unless File.extname(fp).empty?

      # No more processing required when a file extension was not provided, and the default file extension is disabled.
      return fp if !default_file_ext || default_file_ext.empty?

      # Only add a period if the file doesn't end with a period, or the extension doesn't begin with one.
      sep = default_file_ext[0] == '.' || fp[-1] == '.' ? '' : '.'

      # Add the default file extension.
      [fp, default_file_ext].join(sep)
    end

    # Renders the template partial at the given path.
    #
    # @param [*String] partial_path Path relative to the path given when initializing the Document.
    # @return [Array | Hash]
    def render(*partial_path)
      template_path = full_path(*partial_path)

      code = File.read(template_path)

      @output = eval(code, binding, template_path.to_s)
    end

    # Saves the document.
    #
    # @param [Pathname | String] full_path
    # @return [String]
    def save(full_path)
      File.write(full_path, to_json)
    end

    # Creates the JSON for the rendered templates.
    #
    # @return [String]
    def to_json
      pretty ? JSON.pretty_generate(output) : output.to_json
    end
  end
end
