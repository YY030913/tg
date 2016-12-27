Package.describe({
	name: 'tagt:sms',
	version: '0.0.1',
	summary: '',
	git: '',
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('tagt:lib');

	api.addFiles('settings.js', 'server');
	api.addFiles('SMS.js', 'server');
	api.addFiles('services/twilio.js', 'server');
});

Npm.depends({
	'twilio': '2.9.1'
});
