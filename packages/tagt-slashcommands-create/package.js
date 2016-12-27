Package.describe({
	name: 'tagt:slashcommands-create',
	version: '0.0.1',
	summary: 'Command handler for the /create command',
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
	api.addFiles('server.js', 'server');
});
