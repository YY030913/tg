Package.describe({
	name: 'tagt:slashcommands-leave',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate /leave commands',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'tagt:lib'
	]);
	api.addFiles('leave.coffee');
});
