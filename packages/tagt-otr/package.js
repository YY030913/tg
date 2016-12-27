Package.describe({
	name: 'tagt:otr',
	version: '0.0.1',
	summary: 'Off-the-record messaging for TalkGet',
	git: ''
});

Package.onUse(function(api) {

	api.use([
		'ecmascript',
		'less',
		'tagt:lib',
		'tracker',
		'reactive-var'
	]);

	api.use('templating', 'client');

	api.addFiles([
		'client/tagt.otr.js',
		'client/tagt.otr.room.js',
		'client/stylesheets/otr.less',
		'client/views/otrFlexTab.html',
		'client/views/otrFlexTab.js',
		'client/tabBar.js'
	], 'client');

	api.addFiles([
		'server/settings.js',
		'server/models/Messages.js',
		'server/methods/deleteOldOTRMessages.js',
		'server/methods/updateOTRAck.js'
	], 'server');
});
