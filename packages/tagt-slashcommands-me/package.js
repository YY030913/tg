Package.describe({
	name: 'tagt:slashcommands-me',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate /me commands',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'tagt:lib'
	]);

	api.addFiles('me.coffee', ['server', 'client']);
});
