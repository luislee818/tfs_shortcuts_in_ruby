def get_default_commands(options)
	[
		# tf get
		{
			name: 'getd',
			description: "Get latest version of Dev branch",
			command_output_banner: "Get latest version of #{options[:dev_branch]} to #{options[:local_full_path]}",
			command_to_exec: "echo getd"
		},
		{
			name: 'geti',
			description: "Get latest version of Integration branch",
			command_output_banner: "Get latest version of #{options[:int_branch]} to #{options[:local_full_path]}",
			command_to_exec: "echo geti"
		},
		# tf checkin
		{
			name: 'checkind',
			description: "Checkin changes in Dev branch (GUI)",
			command_output_banner: "Checkin files to #{options[:dev_branch]}",
			command_to_exec: "echo checkinD"
		},
		{
			name: 'checkini',
			description: "Checkin changes in Integration branch (GUI)",
			command_output_banner: "Checkin files to #{options[:int_branch]}",
			command_to_exec: "echo checkinI"
		},
		{
			name: 'checkinifff',
			description: "Checkin changes in Integration branch with default checkin notes (no prompts)",
			command_output_banner: "Checkin files to #{options[:int_branch]} without prompt",
			command_to_exec: "echo checkinIfff"
		},
		# tf merge
		{
			name: 'mergedi',
			description: "Merge from Dev to Integration branch",
			command_output_banner: "Merge from #{options[:dev_branch]} to #{options[:int_branch]}",
			command_to_exec: "echo mergeDI"
		},
		# tf resolve
		{
			name: 'resolve_with_theirs',
			description: "Resolving merge conflicts by taking from source branch",
			command_output_banner: "Resolving merge conflicts by taking from source branch",
			command_to_exec: "echo resolve_with_theirs"
		}
	]
end
