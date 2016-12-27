Package.describe({
	name: 'tagt:sandstorm',
	version: '0.0.1',
	summary: 'Sandstorm integeration for TalkGet',
	git: ''
});

Package.onUse(function(api) {
	api.use([ 'ecmascript', 'tagt:lib' ]);

	api.addFiles([ 'server/lib.js', 'server/events.js', 'server/powerbox.js' ], 'server');
	api.addFiles([ 'client/powerboxListener.js' ], 'client');
});
