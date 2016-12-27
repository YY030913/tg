Package.describe({
	name: 'tagt:message-mark-as-unread',
	version: '0.0.1',
	summary: 'Mark a message as unread'
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'underscore',
		'less',
		'tagt:lib',
		'tagt:logger',
		'tagt:ui'
	]);

	api.use('templating', 'client');

	api.addFiles([
		'client/actionButton.coffee'
	], 'client');

	api.addFiles([
		'server/logger.js',
		'server/unreadMessages.coffee'
	], 'server');
});
