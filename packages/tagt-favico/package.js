Package.describe({
	name: 'tagt:favico',
	version: '0.0.1',
	summary: 'Favico.js for TalkGet'
});

Package.onUse(function(api) {
	api.use([
		'coffeescript'
	], 'client');
	api.addFiles([
		'favico.js'
	], 'client');
});
