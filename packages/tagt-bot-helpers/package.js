Package.describe({
	name: 'tagt:bot-helpers',
	version: '0.0.1',
	summary: 'Add some helper methods to TalkGet for bots to use.',
	git: 'https://github.com/timkinnane/tagt-bot-helpers'
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('underscore');
	api.use('tagt:lib');
	api.use('accounts-base');
	// api.mainModule('server/index.js', 'server'); // when 1.3
	// api.mainModule('client/index.js', 'client'); // when 1.3
	api.addFiles([
		'server/index.js',
		'server/settings.js'
	], ['server']);
});
