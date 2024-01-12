# DryValidationParser

Generate a readable hash by parsing the abstract syntax tree of a Dry::Validation::Contract schema

The gem is still work in progress and is not yet fully tested.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dry_validation_parser'
```

And then execute:

    bundle install

After installing, execute the following command:

    rake dry_validation_parser:install

This will generate configuration files in your project under `project/config/initializers`. See Configuration section for more details.

## Usage

#### Parsing a Dry::Validation::Contract
Lets say we have the following Dry::Validation::Contract definition:

    class TestContract < Dry::Validation::Contract
        params do
            required(:some_field).value(:str?, min_size?: 5, max_size?: 10)
            required(:some_array_of_objects).array(:hash) do
                required(:some_nested_attribute).value(:str?)
            end
            required(:some_array_of_integers).array(:int?)
            required(:dto).value(:hash) do
                optional(:some_nested_attribute).maybe(:str?)
            end
        end
    end
    
    parser = DryValidationParser::ValidationSchemaParser.new

`parser.call(TestContract)` will set the `keys` of the `parser` object to:

    {
        :some_field => {
            :required => true,
            :type => "string",
            :description => "Minimum size: 5, Maximum size: 10"
        },
         :some_array_of_objects => { 
            :required => true,
            :array => true,
            :type => "array",
            :keys => {
                :some_nested_attribute => {
                    :required=>true, :type=>"string"
                }
            }
         },
         :some_array_of_integers => {
            :required=>true, 
            :array=>true, 
            :type=>"integer"
         },
         :dto => {
            :required => true,
            :type => "hash",
            :keys => {
                :some_nested_attribute => {
                    :required => false, 
                    :"x-nullable"=>true, 
                    :type=>"string"
                }
            }
         }
    }

As we can see, the `DryValidationParser::ValidationSchemaParser` goes through all the params defined in the
schema and generates a hash. The hash is saved in the `keys` attribute of the parser.

The required key in our result will be set to `true` if the field is defined as
`required(:field_name)`, and `false` if defined as `optional(:field_name)`.

The "x-nullable" key depends on whether we have defined the field as value, maybe or filled.

For nested objects like array of objects or hash, we add a keys field with a definition
for each field inside the nested hash.

If the field is an array of primitive type, the type field will equal to the primitive type, and a
array flag will be set on the field.

## Custom Configuration For Your Project
You can override default configurations by changing the values in the `config/initializers/dry_validation_parser.rb` file generated from the rake command in the Installation section.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Jane-Terziev/dry_validation_parser. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dry_validation_parser/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dry::Validation::Parser project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Jane-Terziev/dry_validation_parser/blob/master/CODE_OF_CONDUCT.md).
