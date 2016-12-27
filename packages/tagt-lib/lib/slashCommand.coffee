TAGT.slashCommands =
	commands: {}

TAGT.slashCommands.add = (command, callback, options) ->
	TAGT.slashCommands.commands[command] =
		command: command
		callback: callback
		params: options?.params
		description: options?.description
		clientOnly: options?.clientOnly or false

	return

TAGT.slashCommands.run = (command, params, item) ->
	if TAGT.slashCommands.commands[command]?.callback?
		callback = TAGT.slashCommands.commands[command].callback
		callback command, params, item


Meteor.methods
	slashCommand: (command) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'slashCommand' }

		TAGT.slashCommands.run command.cmd, command.params, command.msg

