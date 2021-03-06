Package.describe({
	name: 'tagt:importer-slack',
	version: '0.0.1',
	summary: 'Importer for Slack',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'tagt:lib',
		'tagt:importer'
	]);
	api.use(['mrt:moment-timezone@0.2.1'], 'server');
	api.use('tagt:logger', 'server');
	api.addFiles('server.coffee', 'server');
	api.addFiles('main.coffee', ['client', 'server']);
});
