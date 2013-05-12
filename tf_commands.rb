class TFCommand
	def initialize(name, tf_path=nil)
		@name = name
		@tf_path = tf_path
	end

	def get_tf
		@tf_path || 'tf'
	end
end

class TFGetCommand < TFCommand
	def initialize(itemspec, tf_path=nil)
		@itemspec = itemspec
		super('Get', tf_path)
	end

	def description
		%Q{Retrieves a read-only copy of a file from \
			the Team Foundation Server to the workspace \
			and creates folders on disk to contain it.
			see http://msdn.microsoft.com/en-us/library/fx7sdeyf(v=vs.100).aspx}
	end

	def get_raw_command
		%Q("#{get_tf}" get #{@itemspec})
	end
end

class TFCheckinCommand < TFCommand
	def initialize(itemspec, comment, tf_path=nil)
		@itemspec = itemspec
		@comment = comment
		super('Checkin', tf_path)
	end

	def description
		%Q{Commits pending changes in the current \
			workspace to the server for Team Foundation version control.
			see http://msdn.microsoft.com/en-us/library/c327ca1z(v=vs.100).aspx}
	end

	def get_raw_command
		%Q("#{get_tf}" checkin /comment:"#{@comment}" #{@itemspec})
	end
end

class TFMergeCommand < TFCommand
	def initialize(source_branch, target_branch, tf_path=nil)
		@source_branch = source_branch
		@target_branch = target_branch
		super('Merge', tf_path)
	end

	def description
		%Q{The merge command applies changes from one branch into another. \
		http://msdn.microsoft.com/en-us/library/bd6dxhfy(v=vs.100).aspx}
	end

	def get_raw_command
		%Q("#{get_tf}" merge #{@source_branch} #{@target_branch})
	end
end

class TFResolveCommand < TFCommand
	def initialize(tf_path=nil, resolve_option='TakeTheirs')
		@resolve_option = resolve_option
		super('Resolve', tf_path)
	end

	def description
		%Q{Lets you resolve conflicts between changed items in your workspace \
		and the latest or destination versions of items on the server.
		http://msdn.microsoft.com/en-us/library/6yw3tcdy(v=vs.100).aspx}
	end

	def get_raw_command
		%Q("#{get_tf}" resolve /auto:#{@resolve_option})
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
		old_raw = super
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
		old_raw = super
		make_recursive old_raw
	end

	private

	def make_recursive(raw_tf_command)
		"#{raw_tf_command} /recursive"
	end
end

class TFCommandSuppressPromptDecorator < TFCommandDecorator
	def initialize(command)
		super command
	end

	def name
		"#{command.name} without prompt"
	end

	def get_raw_command
		old_raw = super
		suppress_prompt old_raw
	end

	private

	def suppress_prompt(raw_tf_command)
		"#{raw_tf_command} /noprompt"
	end
end

class TFCommandRecursiveDecorator < TFCommandDecorator
	def name
		"#{command.name} recursively"
	end

	def get_raw_command
		old_raw = super
		make_recursive old_raw
	end

	private

	def make_recursive(raw_tf_command)
		"#{raw_tf_command} /recursive"
	end
end
