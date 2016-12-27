Package.describe({
	name: 'tagt:irc',
	version: '0.0.1',
	summary: 'TAGT libraries',
	git: ''
});

Npm.depends({
	'coffee-script': '1.9.3',
	'lru-cache': '2.6.5'
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'underscore',
		'tagt:lib'
	]);

	api.addFiles('irc.server.coffee', 'server');
	api.export(['Irc'], ['server']);
});
