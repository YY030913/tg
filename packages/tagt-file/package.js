Package.describe({
	name: 'tagt:file',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.use('tagt:lib');
	api.use('tagt:version');
	api.use('coffeescript');

	api.addFiles('file.server.coffee', 'server');

	api.export('TAGTFile', 'server');
});

Npm.depends({
	'mkdirp': '0.5.1',
	'gridfs-stream': '1.1.1',
	'gm': '1.23.0'
});
