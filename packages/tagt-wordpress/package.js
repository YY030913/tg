Package.describe({
	name: 'tagt:wordpress',
	version: '0.0.1',
	summary: 'TAGT settings for WordPress Oauth Flow'
});

Package.onUse(function(api) {
	api.use('coffeescript');
	api.use('tagt:lib');
	api.use('tagt:custom-oauth');

	api.use('templating', 'client');

	api.addFiles('common.coffee');
	api.addFiles('wordpress-login-button.css', 'client');
	api.addFiles('startup.coffee', 'server');
});
