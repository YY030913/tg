Package.describe({
	name: 'tagt:slashcommands-open',
	version: '0.0.1',
	summary: 'Command handler for the /open command',
	git: ''
});

Package.onUse(function(api) {

	api.use([
		'ecmascript',
		'check',
		'tagt:lib',
		'kadira:flow-router'
	]);

	api.use('templating', 'client');

	api.addFiles('client.js', 'client');
});
