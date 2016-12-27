Package.describe({
	name: 'tagt:tutum',
	version: '0.0.1',
	summary: 'TAGT tutum integration'
});

Package.onUse(function(api) {
	api.use('coffeescript');
	api.use('tagt:lib');

	api.addFiles('startup.coffee', 'server');
});

Npm.depends({
	'redis': '2.2.5'
});
