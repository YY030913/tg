Package.describe({
	name: 'tagt:statistics',
	version: '0.0.1',
	summary: 'Statistics generator',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'tagt:lib'
	]);

	// Statistics
	api.addFiles('lib/tagt.coffee', [ 'client', 'server' ]);
	api.addFiles([
		'server/models/Statistics.coffee',
		'server/models/MRStatistics.coffee',
		'server/functions/get.coffee',
		'server/functions/save.coffee',
		'server/methods/getStatistics.coffee'
	], 'server');
});
