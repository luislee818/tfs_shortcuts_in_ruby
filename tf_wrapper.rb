#!/usr/bin/env ruby

require 'yaml'
require_relative 'default_commands'

# get configuration from rc file
CONFIG_FILE_NAME = 'tfr.rc.yaml'
options = {
	default_commands_file: './default_commands.rb'
}

config_file = File.join(File.expand_path(File.dirname(__FILE__)), CONFIG_FILE_NAME)
if File.exists? config_file
	config_options = YAML.load_file(config_file)
	options.merge!(config_options)
end

DEFAULT_COMMANDS = get_default_commands options

pre_process_commands! DEFAULT_COMMANDS

def pre_process_commands!(commands)

end

class TFWrapper
	def self.inject_commands(commands)
		@@commands = commands

		commands.each do |command|
			define_method command[:name] do
				puts command[:command_output_banner]

				command_to_exec = get_command_to_exec command

				execute command_to_exec
			end
		end

	end

	def self.get_command_to_exec(command)
		if should_append_login? command
			append_login(command)
		else
			command[:command_to_exec]
		end
	end

	def self.should_append_login?(command)
		!command[:username].nil?
	end

	def self.append_login(command)
		"#{command_to_exec} /login:#{}"

	end

	inject_commands DEFAULT_COMMANDS

	def initialize(configs)
		@configs = configs
		puts @configs
	end

	def execute(command)
		send command.downcase
	end

	def show_configs
		puts "Configurations loaded:"

		@configs.each do |k, v|
			puts "#{k}: #{v}"
		end
	end

	def show_supported_commands
		puts "Supported commands:"

		@@commands.each do |command|
			puts "#{command[:name]} - #{command[:description]}"
		end
	end

	def method_missing(method_name, *args)
		puts "Do not understand command #{method_name}"
		show_configs
		show_supported_commands
	end
end

command_from_input = ARGV[0]
wrapper = TFWrapper.new(options)
wrapper.execute command_from_input