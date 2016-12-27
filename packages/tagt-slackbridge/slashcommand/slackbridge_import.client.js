TAGT.settings.onload('SlackBridge_Enabled', (key, value) => {
	if (value) {
		TAGT.slashCommands.add('slackbridge-import', null, {
			description: 'Import_old_messages_from_slackbridge'
		});
	} else {
		delete TAGT.slashCommands.commands['slackbridge-import'];
	}
});
