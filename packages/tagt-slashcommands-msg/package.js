Package.describe({
	name: 'tagt:slashcommands-msg',
	version: '0.0.1',
	summary: 'Command handler for the /msg command',
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
