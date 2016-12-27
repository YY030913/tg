Package.describe({
	name: 'tagt:slashcommands-archive',
	version: '0.0.1',
	summary: 'Command handler for the /room command',
	git: ''
});

Package.onUse(function(api) {

	api.use([
		'ecmascript',
		'check',
		'tagt:lib'
	]);

	api.use('templating', 'client');

	api.addFiles('client.js', 'client');
	api.addFiles('messages.js', 'server');
	api.addFiles('server.js', 'server');
});
