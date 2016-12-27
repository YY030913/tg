Package.describe({
	name: 'tagt:message-star',
	version: '0.0.1',
	summary: 'Star Messages',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'underscore',
		'less',
		'tagt:lib'
	]);

	api.use('templating', 'client');

	api.addFiles([
		'client/lib/StarredMessage.coffee',
		'client/actionButton.coffee',
		'client/starMessage.coffee',
		'client/tabBar.coffee',
		'client/views/starredMessages.html',
		'client/views/starredMessages.coffee',
		'client/views/stylesheets/messagestar.less',

		'client/views/starredMessagesPage.html',
		'client/views/starredMessagesPage.coffee'
	], 'client');

	api.addFiles([
		'server/settings.coffee',
		'server/starMessage.coffee',
		'server/publications/starredMessages.coffee',
		'server/startup/indexes.coffee'
	], 'server');
});
