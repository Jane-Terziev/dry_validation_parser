require 'fileutils'

namespace 'dry_validation_parser' do
  desc 'Create a configuration file for Dry Validation'
  task :create_configuration_file do
    FileUtils.mkdir_p "#{ Dir.pwd }/config/initializers/"
    puts "Created #{ Dir.pwd }/config/initializers/dry_validation_parser.rb"
    File.open("#{ Dir.pwd }/config/initializers/dry_validation_parser.rb", "w") { |file|
file.puts 'DryValidationParser::Config::ValidationConfiguration.configuration do |config|
  config.enable_required_validation = true
  config.enable_nullable_validation = true
  config.enable_enums = true
  config.enable_descriptions = true
  config.nullable_type = :"x-nullable" # or :nullable
end'
    }
  end

  desc 'Create a YAML file for Dry Validation field descriptions'
  task :create_validation_descriptions_yaml do
    FileUtils.mkdir_p "#{ Dir.pwd }/config/locales/"
    puts "Created #{ Dir.pwd }/config/locales/dry_validation_parser.yml"
    File.open("#{ Dir.pwd }/config/locales/dry_validation_parser.yml", "w") { |file|
file.puts 'en:
  validation:
    descriptions:
      eql?: "Must be equal to %{value}"
      max_size?: "Maximum size: %{value}"
      min_size?: "Minimum size: %{value}"
      gteq?: "Greater than or equal to %{value}"
      gt?: "Greater than %{value}"
      lt?: "Lower than %{value}"
      lteq?: "Lower than or equal to %{value}"
'
    }
  end

  desc 'Creates configuration files'
  task :install do
    Rake::Task['dry_validation_parser:create_configuration_file'].execute
    Rake::Task['dry_validation_parser:create_validation_descriptions_yaml'].execute
  end
end