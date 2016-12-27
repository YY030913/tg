Package.describe({
	name: 'tagt:autolinker',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate links on messages',
	git: ''
});

Npm.depends({
	autolinker: '1.1.0'
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('tagt:lib');

	api.addFiles('client.js', 'client');

	api.addFiles('settings.js', 'server');
});
