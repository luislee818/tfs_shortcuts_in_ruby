#TFS Shortcuts in Ruby

##Introduction
This is a rewritten project of my previous [TFS Shortcuts](https://github.com/luislee818/TFS_Shortcuts) project, using Ruby.

The shortcuts are just some wrappers around [tf][1] commands used in Team Foundation Server.

Assuming you use a Main branch and Integration branch, there are some coarse-grained commands used everyday than built-in tf commands:

* Get latest of Dev branch
* Get latest of Integration branch
* Merge from Dev to Integration branch
* Resolve conflicts on merge
* Checkin Integration
* Custom workflow
	* Automated merge from Dev to Integration branch (consists of all five commands above)
	* ...

##Configuration
Options can be specified in *configs.yaml* file:
```yaml
---
:workspace_path: absolute_path_to_workspace
:dev_branch: dev_branch_name
:int_branch: integratio_branch_name
:merge_int_checkin_note: checkin_note_for_merge_to_integration
:username: username_to_execute_tf_commands
:password: password_to_execute_tf_commands
:custom_commands_file: custom_commands_file_written_in_ruby
:tf_path: path_to_tf_command
```

## Execution
To execute a specific command:
```bash
$ ruby tfsr.rb [command_name]
```

## Commands
Built-in commands:
* get_dev
* get_integration
* merge\_dev\_to_int
* resolve
* checkin\_int\_without\_prompt
* log

Built-in custom commands:
* workflow\_merge\_dev\_to\_int

[1]: http://msdn.microsoft.com/en-us/library/z51z7zy0(v=vs.100).aspx