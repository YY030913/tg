Package.describe({
	name: 'tagt:error-handler',
	version: '1.0.0',
	summary: 'TalkGet Error Handler',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'ecmascript',
		'tagt:lib',
		'templating'
	]);

	api.addFiles('server/lib/TAGT.ErrorHandler.js', 'server');
	api.addFiles('server/startup/settings.js', 'server');
});
