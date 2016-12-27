Package.describe({
	name: 'tagt:sharedsecret',
	version: '0.0.1',
	summary: 'TAGT libraries',
	git: ''
});

Package.onUse(function(api) {
	api.use([
		'coffeescript',
		'tagt:lib'
	]);

	api.use(['jparker:crypto-aes'], ['server', 'client']);

	api.addFiles('sharedsecret.coffee', ['server', 'client']);
});
