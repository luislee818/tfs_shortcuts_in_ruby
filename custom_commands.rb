add_command 'workflow_fancy_get_dev' do
	log '---------- Getting Dev branch --------'
	get_dev
	log '---------- Get Dev branch done --------'
end

add_command 'workflow_merge_dev_to_int' do
	log '---------- Getting Dev branch --------'
	get_dev
	log '---------- Get Dev branch done --------'

	log '---------- Getting Integration branch --------'
	get_integration
	log '---------- Get Integration branch done --------'

	log '---------- Merging from Dev to Integration branch without prompt --------'
	merge_dev_to_int_without_prompt
	log '---------- Merge from Dev to Integration branch done --------'

	log '---------- Resolving potential merge conflicts by taking from source --------'
	resolve
	log '---------- Resolve potential merge conflicts done --------'

	log '---------- Checking in merge results to Integration without prompt --------'
	checkin_int_without_prompt
end
