Package.describe({
	name: 'tagt:smarsh-connector',
	version: '0.0.1',
	summary: 'Smarsh Connector',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'ecmascript',
		'tagt:lib',
		'underscore',
		'mrt:moment',
		'mrt:moment-timezone'
	]);

	api.addFiles('lib/tagt.js', [ 'client', 'server' ]);
	api.addFiles([
		'server/settings.js',
		'server/models/SmarshHistory.js',
		'server/functions/sendEmail.js',
		'server/functions/generateEml.js',
		'server/startup.js'
	], 'server');
});
