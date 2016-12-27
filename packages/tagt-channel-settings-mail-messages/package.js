Package.describe({
	name: 'tagt:channel-settings-mail-messages',
	version: '0.0.1',
	summary: 'Channel Settings - Mail Messages',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'templating',
		'reactive-var',
		'less',
		'tagt:lib',
		'tagt:channel-settings',
		'momentjs:moment'
	]);

	api.addFiles([
		'client/lib/startup.coffee',
		'client/stylesheets/mail-messages.less',
		'client/views/channelSettingsMailMessages.html',
		'client/views/channelSettingsMailMessages.coffee',
		'client/views/mailMessagesInstructions.html',
		'client/views/mailMessagesInstructions.coffee'
	], 'client');


	api.addFiles([
		'server/lib/startup.coffee',
		'server/methods/mailMessages.coffee'
	], 'server');
});
