Package.describe({
	name: 'tagt:tooltip',
	version: '0.0.1',
	summary: '',
	git: '',
	documentation: 'README.md'
});

Package.onUse(function(api) {
	api.use('ecmascript');
	api.use('templating', 'client');
	api.use('tagt:lib');
	api.use('tagt:theme');
	api.use('tagt:ui-master');

	api.addAssets('tooltip.less', 'server');
	api.addFiles('loadStylesheet.js', 'server');

	api.addFiles('tagt-tooltip.html', 'client');
	api.addFiles('tagt-tooltip.js', 'client');

	api.addFiles('init.js', 'client');
});
