Package.describe({
	name: 'tagt:reactions',
	version: '0.0.1',
	summary: '',
	git: '',
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('templating');
	api.use('tagt:lib');
	api.use('tagt:theme');
	api.use('tagt:ui');

	api.addFiles('client/init.js', 'client');

	api.addFiles('server/models/Messages.js');
	api.addFiles('client/methods/setReaction.js', 'client');
	api.addFiles('setReaction.js', 'server');

	api.addAssets('client/stylesheets/reaction.less', 'server');
	api.addFiles('loadStylesheets.js', 'server');
});
