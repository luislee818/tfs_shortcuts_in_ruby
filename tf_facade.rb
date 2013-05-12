require_relative 'tf_command'

class TFFacade
	def initialize(options)
		@options = options
	end

	def initialize_from_file(path)
		instance_eval(File.read(path))
	end

	def add_command(name, &block)
		self.class.send(:define_method, name) do
			instance_eval(&block)
		end
	end

	def get_dev
		log "Get latest of #{@options[:dev_branch]} to #{@options[:workspace_path]}"
		recursive_get_branch @options[:dev_branch]
	end

	def get_integration
		log "Get latest of #{@options[:int_branch]} to #{@options[:workspace_path]}"
		recursive_get_branch @options[:int_branch]
	end

	def merge_dev_to_int_without_prompt
		log "Merge from #{@options[:dev_branch]} to #{@options[:int_branch]}"
		command = TFMergeCommand.new(@options[:dev_branch], @options[:int_branch])
		command = suppress_prompt(append_login_if_necessary(make_recursive(command)))

		execute_core command
	end

	def resolve
		log "Resolve merge conflicts by taking from source"
		command = TFResolveCommand.new
		command = append_login_if_necessary(make_recursive(command))

		execute_core command
	end

	def checkin_int_without_prompt
		log "Checkin to #{@options[:int_branch]} without prompt"
		command = TFCheckinCommand.new(@options[:int_branch], @options[:merge_int_checkin_note])
		command = suppress_prompt(append_login_if_necessary(make_recursive(command)))

		execute_core command
	end

	def log(message)
		puts message
	end

	def execute(command)
		send command.downcase
	end

	def method_missing(method_name, *args)
		log "Do not understand command #{method_name}"
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

		system raw_command
	end

	# uncomment to test
	# def exec(command)
	# 	puts command
	# end
end
