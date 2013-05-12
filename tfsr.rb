#!/usr/bin/env ruby

require 'yaml'
require_relative 'tf_facade'

# load options
CONFIG_FILE_NAME = 'configs.yaml'
options = {
}

config_file = File.join(File.expand_path(File.dirname(__FILE__)), CONFIG_FILE_NAME)
if File.exists? config_file
	config_options = YAML.load_file(config_file)
	options.merge!(config_options)
end

# load custom commands file if necessary
unless options[:custom_commands_file].nil?
	custom_commands_file = File.join(File.expand_path(File.dirname(__FILE__)), options[:custom_commands_file])
end

# grab user's input command
command_from_input = ARGV[0]

# initialize our TFFacade
facade = TFFacade.new(options)
if File.exists? custom_commands_file
	facade.initialize_from_file custom_commands_file
end

# pass command to our TFFacade
facade.execute command_from_input
