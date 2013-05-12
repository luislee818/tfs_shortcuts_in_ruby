add_command 'workflow_fancy_get_dev' do
	log '---------- Getting Dev branch --------'
	get_dev
	log '---------- Get Dev branch Done --------'
end

add_command 'workflow_merge_dev_to_int' do
	get_dev
	get_integration
	merge_dev_to_int
	resolve
	checkin_int_without_prompt
end
