# frozen_string_literal: true

module DryValidationParser
  module Config
    module ValidationConfiguration
      extend Configuration

      define_setting :enable_required_validation, true
      define_setting :enable_nullable_validation, true
      define_setting :enable_enums, true
      define_setting :enable_descriptions, true
      define_setting :nullable_type, :"x-nullable"
    end
  end
end
