class TFCommand
	def initialize(name, options)
		@name = name
		@options = options
	end

	def name
		@name
	end

	def description
		'A TF command'
	end

	def get_raw_command
		raise 'should be implemented in subclasses'
	end
end

class TFGetCommand < TFCommand
	def initialize(options)
		super('Get', options)
	end

	def description
		%Q{Retrieves a read-only copy of a file from \
			the Team Foundation Server to the workspace \
			and creates folders on disk to contain it.
			see http://msdn.microsoft.com/en-us/library/fx7sdeyf(v=vs.100).aspx}
	end

	def get_raw_command
		"tf get #{@options[:itemspec]}"
	end
end

class TFCheckinCommand < TFCommand
	def initialize(options)
		super('Checkin', options)
	end

	def description
		%Q{Commits pending changes in the current \
			workspace to the server for Team Foundation version control.
			see http://msdn.microsoft.com/en-us/library/c327ca1z(v=vs.100).aspx}
	end

	def get_raw_command
		"tf checkin /comment:#{@options[:comment]} #{@options[:itemspec]}"
	end
end

class TFCommandDecorator
	def initialize(command)
		@command = command
	end

	def name
		@command.name
	end

	def description
		@command.description
	end

	def get_raw_command
		@command.get_raw_command
	end
end

class TFCommandAppendLoginDecorator < TFCommandDecorator
	def initialize(command, username, password)
		@username = username
		@password = password
		super command
	end

	def name
		"#{command.name} with specified login"
	end

	def get_raw_command
		old_raw = super.get_raw_command
		append_login old_raw
	end

	private

	def append_login(raw_tf_command)
		"#{raw_tf_command} /login:#{@username},#{@password}"
	end
end

class TFCommandRecursiveDecorator < TFCommandDecorator
	def name
		"#{command.name} recursively"
	end

	def get_raw_command
		old_raw = @command.get_raw_command
		make_recursive old_raw
	end

	private

	def make_recursive(raw_tf_command)
		"#{raw_tf_command} /recursive"
	end
end
