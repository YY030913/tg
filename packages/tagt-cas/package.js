Package.describe({
	name: 'tagt:cas',
	summary: 'CAS support for accounts',
	version: '1.0.0',
	git: 'https://github.com/tagt/tagt-cas'
});

Package.onUse(function(api) {
	// Server libs
	api.use('tagt:lib', 'server');
	api.use('tagt:logger', 'server');
	api.use('service-configuration', 'server');
	api.use('routepolicy', 'server');
	api.use('webapp', 'server');
	api.use('accounts-base', 'server');

	api.use('underscore');
	api.use('ecmascript');

	// Server files
	api.add_files('cas_tagt.js', 'server');
	api.add_files('cas_server.js', 'server');

	// Client files
	api.add_files('cas_client.js', 'client');

});

Npm.depends({
	cas: '0.0.3'
});
