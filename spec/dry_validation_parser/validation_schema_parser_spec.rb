# frozen_string_literal: true

require "spec_helper"

RSpec.describe DryValidationParser::ValidationSchemaParser do
  type_definitions = {
    'Nominal types': %w[
      DryValidationParser::Types::Nominal::Bool
      DryValidationParser::Types::Nominal::Integer
      DryValidationParser::Types::Nominal::Float
      DryValidationParser::Types::Nominal::Decimal
      DryValidationParser::Types::Nominal::String
      DryValidationParser::Types::Nominal::Date
      DryValidationParser::Types::Nominal::DateTime
      DryValidationParser::Types::Nominal::Time
    ],
    'Strict types': %w[
      DryValidationParser::Types::Strict::Bool
      DryValidationParser::Types::Strict::Integer
      DryValidationParser::Types::Strict::Float
      DryValidationParser::Types::Strict::Decimal
      DryValidationParser::Types::Strict::String
      DryValidationParser::Types::Strict::Date
      DryValidationParser::Types::Strict::DateTime
      DryValidationParser::Types::Strict::Time
    ],
    'Coercible types': %w[
      DryValidationParser::Types::Coercible::String
      DryValidationParser::Types::Coercible::Integer
      DryValidationParser::Types::Coercible::Float
      DryValidationParser::Types::Coercible::Decimal
    ],
    'Params types': %w[
      DryValidationParser::Types::Params::Date
      DryValidationParser::Types::Params::DateTime
      DryValidationParser::Types::Params::Time
      DryValidationParser::Types::Params::Bool
      DryValidationParser::Types::Params::Integer
      DryValidationParser::Types::Params::Float
      DryValidationParser::Types::Params::Decimal
    ],
    'JSON types': %w[
      DryValidationParser::Types::JSON::Date
      DryValidationParser::Types::JSON::DateTime
      DryValidationParser::Types::JSON::Time
      DryValidationParser::Types::JSON::Decimal
    ]
  }

  schema_types = {
    'Schema types': %w[
      int?
      str?
      bool?
      uuid_v1?
      uuid_v2?
      uuid_v3?
      uuid_v4?
      uuid_v5?
    ]
  }

  let(:contract) do
    Class.new(ApplicationContract)
  end

  subject { described_class.new }

  describe "#.visit(Contract.schema.ast)" do
    type_definitions.each_value do |array_of_types|
      context "required(:field).value(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                required(:"field#{index}").value(Object.const_get(type))
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end
      context "required(:field).filled(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                required(:"field#{index}").filled(Object.const_get(type))
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).maybe(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                required(:"field#{index}").maybe(Object.const_get(type))
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).value(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").value(Object.const_get(type))
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).filled(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").filled(Object.const_get(type))
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).maybe(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").maybe(Object.const_get(type))
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).maybe(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").maybe(Object.const_get(type))
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).array(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").array(Object.const_get(type))
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).value(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").value(Object.const_get(type))
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).maybe(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").maybe(Object.const_get(type))
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).filled(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").filled(Object.const_get(type))
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).value(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  optional(:"field#{index}").filled(Object.const_get(type))
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).maybe(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").filled(Object.const_get(type))
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).filled(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").filled(Object.const_get(type))
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end
    end

    schema_types.each_value do |array_of_types|
      context "required(:field).value(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                required(:"field#{index}").value(:"#{type}")
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).filled(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                required(:"field#{index}").filled(:"#{type}")
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).maybe(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                required(:"field#{index}").maybe(:"#{type}")
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).array(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                required(:"field#{index}").array(:"#{type}")
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).value(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").value(:"#{type}")
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).filled(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").filled(:"#{type}")
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).maybe(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").maybe(:"#{type}")
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "optional(:field).array(:#{array_of_types})" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              array_of_types.each_with_index.map do |type, index|
                optional(:"field#{index}").array(:"#{type}")
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).value(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").value(:"#{type}")
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).maybe(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").maybe(:"#{type}")
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            required(:field).filled(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").filled(:"#{type}")
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).value(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  optional(:"field#{index}").filled(:"#{type}")
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).maybe(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").filled(:"#{type}")
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end

      context "required(:field).hash do
            optional(:field).filled(:#{array_of_types})
        end" do
        it "should parse all fields correctly without raising error" do
          contract = Class.new(Dry::Validation::Contract) do
            json do
              required(:hash).hash do
                array_of_types.each_with_index.map do |type, index|
                  required(:"field#{index}").filled(:"#{type}")
                end
              end
            end
          end
          expect { subject.visit(contract.schema.to_ast) }.to_not raise_error
        end
      end
    end
  end
end
