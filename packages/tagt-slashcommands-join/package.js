Package.describe({
	name: 'tagt:slashcommands-join',
	version: '0.0.1',
	summary: 'Command handler for the /join command',
	git: ''
});

Package.onUse(function(api) {

	api.use([
		'coffeescript',
		'check',
		'tagt:lib'
	]);

	api.use('templating', 'client');

	api.addFiles('client.coffee', 'client');
	api.addFiles('server.coffee', 'server');
});
