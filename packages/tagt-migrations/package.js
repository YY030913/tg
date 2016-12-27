Package.describe({
	name: 'tagt:migrations',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.use('tagt:lib');
	api.use('tagt:version');
	api.use('ecmascript');
	api.use('underscore');
	api.use('check');
	api.use('mongo');
	api.use('momentjs:moment');

	api.addFiles('migrations.js', 'server');
});
