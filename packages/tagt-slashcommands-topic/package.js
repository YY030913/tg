Package.describe({
	name: 'tagt:slashcommands-topic',
	version: '0.0.1',
	summary: 'Command handler for the /topic command',
	git: ''
});

Package.onUse(function(api) {

	api.use([
		'tagt:lib',
		'ecmascript'
	]);

	api.use(['tagt:authorization'], ['client', 'server']);

	api.addFiles('topic.js', ['client', 'server']);
});
