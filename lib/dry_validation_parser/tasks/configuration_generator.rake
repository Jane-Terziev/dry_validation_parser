# frozen_string_literal: true

require "fileutils"

namespace "dry_validation_parser" do
  desc "Create a configuration file for Dry Validation"
  task :create_configuration_file do
    FileUtils.mkdir_p "#{Dir.pwd}/config/initializers/"
    puts "Created #{Dir.pwd}/config/initializers/dry_validation_parser.rb"
    File.open("#{Dir.pwd}/config/initializers/dry_validation_parser.rb", "w") do |file|
      file.puts 'DryValidationParser::Config::ValidationConfiguration.configuration do |config|
  config.enable_required_validation = true
  config.enable_nullable_validation = true
  config.enable_enums = true
  config.enable_descriptions = true
  config.nullable_type = :"x-nullable" # or :nullable
end'
    end
  end

  desc "Create a YAML file for Dry Validation field descriptions"
  task :create_validation_descriptions_yaml do
    FileUtils.mkdir_p "#{Dir.pwd}/config/locales/"
    puts "Created #{Dir.pwd}/config/locales/dry_validation_parser.yml"
    File.open("#{Dir.pwd}/config/locales/dry_validation_parser.yml", "w") do |file|
      file.puts 'en:
  validation:
    descriptions:
      eql?: "Must be equal to %<value>s"
      max_size?: "Maximum size: %<value>s"
      min_size?: "Minimum size: %<value>s"
      gteq?: "Greater than or equal to %<value>s"
      gt?: "Greater than %<value>s"
      lt?: "Lower than %<value>s"
      lteq?: "Lower than or equal to %<value>s"
'
    end
  end

  desc "Creates configuration files"
  task :install do
    Rake::Task["dry_validation_parser:create_configuration_file"].execute
    Rake::Task["dry_validation_parser:create_validation_descriptions_yaml"].execute
  end
end
