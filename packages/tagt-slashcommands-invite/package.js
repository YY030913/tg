Package.describe({
	name: 'tagt:slashcommands-invite',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate /me commands',
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
