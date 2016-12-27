Package.describe({
	name: 'tagt:assets',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'underscore',
		'webapp',
		'tagt:file',
		'tagt:lib',
		'webapp-hashing'
	]);

	api.addFiles('server/assets.coffee', 'server');
});

Npm.depends({
	'image-size': '0.4.0',
	'mime-types': '2.1.9'
});
