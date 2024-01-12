# frozen_string_literal: true

require_relative "dry_validation_parser/version"
require_relative "dry_validation_parser/validation_schema_parser"
require_relative "dry_validation_parser/config/configuration"
require_relative "dry_validation_parser/config/validation_configuration"
require_relative "dry_validation_parser/railtie" if defined?(Rails)

module DryValidationParser
  class Error < StandardError; end
end
