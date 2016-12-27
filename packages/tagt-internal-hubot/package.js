Package.describe({
	name: 'tagt:internal-hubot',
	version: '0.0.1',
	summary: 'Internal Hubot for TalkGet',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'tracker',
		'tagt:lib'
	]);
	api.use('underscorestring:underscore.string');

	api.use('templating', 'client');

	api.addFiles([
		'hubot.coffee',
		'settings.coffee'
	], ['server']);

	api.export('Hubot', ['server']);
	api.export('HubotScripts', ['server']);
	api.export('InternalHubot', ['server']);
	api.export('InternalHubotReceiver', ['server']);
	api.export('TAGTAdapter', ['server']);

});

Npm.depends({
	'coffee-script': '1.10.0',
	'hubot': '2.19.0',
	'hubot-scripts': '2.17.1',
	'hubot-help': '0.2.0'
});
