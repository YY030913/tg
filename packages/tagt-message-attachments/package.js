Package.describe({
	name: 'tagt:message-attachments',
	version: '0.0.1',
	summary: 'Widget for message attachments',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'templating',
		'coffeescript',
		'underscore',
		'tagt:lib'
	]);

	api.addFiles('client/messageAttachment.html', 'client');
	api.addFiles('client/messageAttachment.coffee', 'client');

	// stylesheets
	api.addAssets('client/stylesheets/messageAttachments.less', 'server');
	api.addFiles('client/stylesheets/loader.coffee', 'server');
});
