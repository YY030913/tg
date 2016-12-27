Package.describe({
	name: 'tagt:spotify',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate spotify on messages',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'templating',
		'underscore',
		'tagt:oembed',
		'tagt:lib'
	]);

	api.addFiles('lib/client/widget.coffee', 'client');
	api.addFiles('lib/client/oembedSpotifyWidget.html', 'client');

	api.addFiles('lib/spotify.coffee', ['server', 'client']);
});
