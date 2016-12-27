Package.describe({
	name: 'tagt:api',
	version: '0.0.1',
	summary: 'Rest API',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'underscore',
		'tagt:lib',
		'nimble:restivus'
	]);

	api.addFiles('server/api.coffee', 'server');
	api.addFiles('server/routes.coffee', 'server');
});
