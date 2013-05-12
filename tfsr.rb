#!/usr/bin/env ruby

require 'yaml'
require_relative 'tf_facade'

# get configuration from rc file
CONFIG_FILE_NAME = 'configs.yaml'
options = {
}

config_file = File.join(File.expand_path(File.dirname(__FILE__)), CONFIG_FILE_NAME)
if File.exists? config_file
	config_options = YAML.load_file(config_file)
	options.merge!(config_options)
end

command_from_input = ARGV[0]
facade = TFFacade.new(options)
facade.execute command_from_input
