# frozen_string_literal: true

require 'fileutils'
require 'jsonrb'
require 'minitest/autorun'

# Full path to the project's tmp directory.
TEMP_PATH = Pathname.new(File.expand_path(File.join('..', 'tmp'), __dir__))

# Make sure the tmp directory exists.
FileUtils.mkdir_p(TEMP_PATH) unless File.exists?(TEMP_PATH)

class Minitest::Test
  private

  # @param [*String] path Path to the fixture relative to test/fixtures.
  # @return [String] Full path to the file.
  def fixture_path(*path)
    File.expand_path(File.join('fixtures', *path), __dir__)
  end

  # @param [*String] path Path to the fixture relative to test/fixtures.
  # @return [String] Content of the given fixture.
  def read_fixture(*path)
    File.read(fixture_path(*path))
  end
end
