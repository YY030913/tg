Package.describe({
	name: 'tagt:emoji-emojione',
	version: '0.0.1',
	summary: 'Message pre-processor that will translate emojis',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'ecmascript',
		'emojione:emojione',
		'tagt:emoji',
		'tagt:lib'
	]);

	api.addFiles('emojiPicker.js', 'client');

	api.addFiles('tagt.js', 'client');

	api.addFiles('sprites.css', 'client');
});
