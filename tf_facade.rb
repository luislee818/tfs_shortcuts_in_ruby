require_relative 'tf_command'

class TFFacade
	def initialize(options)
		@options = options

		@drive = options[:workspace_path].match(/(\w:)\\/)[1]
	end

	def get_dev
		puts "Get latest of #{@options[:dev_branch]} to #{@options[:workspace_path]}"
		recursive_get_branch @options[:dev_branch]
	end

	def get_integration
		puts "Get latest of #{@options[:int_branch]} to #{@options[:workspace_path]}"
		recursive_get_branch @options[:int_branch]
	end

	def merge_dev_to_int
		puts "Merge from #{@options[:dev_branch]} to #{@options[:int_branch]}"
		command = TFMergeCommand.new(@options[:dev_branch], @options[:int_branch])
		command = append_login_if_necessary(make_recursive(command))

		execute_core command
	end

	def resolve
		puts "Resolve merge conflicts by taking from source"
		command = TFResolveCommand.new
		command = append_login_if_necessary(make_recursive(command))

		execute_core command
	end

	def checkin_int_without_prompt
		puts "Checkin to #{@options[:int_branch]} without prompt"
		command = TFCheckinCommand.new(@options[:int_branch], @options[:merge_int_checkin_note])
		command = suppress_prompt(append_login_if_necessary(make_recursive(command)))

		execute_core command
	end

	def execute(command)
		send command.downcase
	end

	def method_missing(method_name, *args)
		puts "Do not understand command #{method_name}"
	end

	private

	def recursive_get_branch(branch)
		command = TFGetCommand.new branch
		command = append_login_if_necessary(make_recursive(command))

		execute_core command
	end

	def make_recursive(tf_command)
		TFCommandRecursiveDecorator.new tf_command
	end

	def append_login_if_necessary(tf_command)
		if @options[:username].nil?
			tf_command
		else
			TFCommandAppendLoginDecorator.new(tf_command, @options[:username], @options[:password])
		end
	end

	def suppress_prompt(tf_command)
		TFCommandSuppressPromptDecorator.new tf_command
	end

	def execute_core(tf_command)
		raw_command = tf_command.get_raw_command

		cd_to_workspace
		exec raw_command
	end

	def cd_to_workspace
		exec "cd #{@options[:workspace_path]}"
		exec @drive
	end

	# uncomment to test
	# def exec(command)
	# 	puts command
	# end
end
