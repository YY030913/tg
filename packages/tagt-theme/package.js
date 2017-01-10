Package.describe({
	name: 'tagt:theme',
	version: '0.0.1',
	summary: '',
	git: ''
});

Package.onUse(function(api) {
	api.use('tagt:lib');
	api.use('tagt:logger');
	api.use('tagt:assets');
	api.use('coffeescript');
	api.use('underscore');
	api.use('webapp');
	api.use('webapp-hashing');

	api.use('templating', 'client');


	api.addFiles('server/server.coffee', 'server');
	api.addFiles('server/variables.coffee', 'server');

	api.addFiles('client/minicolors/jquery.minicolors.css', 'client');
	api.addFiles('client/minicolors/jquery.minicolors.js', 'client');


	api.addAssets([
		'assets/stylesheets/fonts/fontello.eot',
		'assets/stylesheets/fonts/fontello.ttf',
		'assets/stylesheets/fonts/fontello.woff',
		'assets/stylesheets/fonts/fontello.woff2',
	], ['client']);

	api.addFiles('assets/stylesheets/fontello.css', 'client');

	api.addAssets('assets/stylesheets/global/_variables.less', 'server');
	api.addAssets('assets/stylesheets/utils/_colors.import.less', 'server');
	api.addAssets('assets/stylesheets/utils/_keyframes.import.less', 'server');
	api.addAssets('assets/stylesheets/utils/_lesshat.import.less', 'server');
	api.addAssets('assets/stylesheets/utils/_preloader.import.less', 'server');
	api.addAssets('assets/stylesheets/utils/_reset.import.less', 'server');
	api.addAssets('assets/stylesheets/utils/_chatops.less', 'server');
	api.addAssets('assets/stylesheets/animation.css', 'server');
	api.addAssets('assets/stylesheets/base.less', 'server');
	// api.addAssets('assets/stylesheets/fontello.css', 'server');
	api.addAssets('assets/stylesheets/rtl.less', 'server');
	api.addAssets('assets/stylesheets/swipebox.min.css', 'server');

	api.addFiles('assets/stylesheets/flag-icon.css', ['client']);

	var _ = Npm.require('underscore');
	var fs = Npm.require('fs');
	var flagFiles = _.compact(_.map(fs.readdirSync('packages/tagt-theme/assets/flags/4x3'), function(filename) {

		if (filename.indexOf('.svg') > -1 && fs.statSync('packages/tagt-theme/assets/flags/4x3/' + filename).size > 16) {
			return 'assets/flags/4x3/' + filename;
		}
	}));
	api.addAssets(flagFiles, 'client');

	var flagFiles = _.compact(_.map(fs.readdirSync('packages/tagt-theme/assets/flags/1x1'), function(filename) {

		if (filename.indexOf('.svg') > -1 && fs.statSync('packages/tagt-theme/assets/flags/1x1/' + filename).size > 16) {
			return 'assets/flags/1x1/' + filename;
		}
	}));
	api.addAssets(flagFiles, 'client');
});

Npm.depends({
	'less': 'https://github.com/meteor/less.js/tarball/8130849eb3d7f0ecf0ca8d0af7c4207b0442e3f6',
	'less-plugin-autoprefix': '1.4.2'
});
