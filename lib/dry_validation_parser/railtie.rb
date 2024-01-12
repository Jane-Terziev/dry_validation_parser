# frozen_string_literal: true

require "dry_validation_parser"
require "rails"

module DryValidationParser
  class Railtie < Rails::Railtie
    railtie_name :dry_validation_parser
  end
end
