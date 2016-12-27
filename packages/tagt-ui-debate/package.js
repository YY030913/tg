Package.describe({
	name: 'tagt:ui-debate',
	version: '0.1.0',
	// Brief, one-line summary of the package.
	summary: '',
	// URL to the Git repository containing the source code for this package.
	git: '',
	// By default, Meteor will default to using README.md for documentation.
	// To avoid submitting documentation, set this field to null.
	documentation: 'README.md'
});

Npm.depends({
  'qiniu': '6.1.9'
  // 'connect-multiparty': '2.0.0'


  // 第二种方案
  // 'multiparty': '4.1.2',
  // 'on-finished': '2.3.0',
  // 'qs': '4.0.0',
  // 'type-is': '1.6.4',
  // "multer": "1.2.0"
});



Package.onUse(function(api) {
	api.versionsFrom('1.2.1');

	api.use('reactive-var');
	api.use('tracker');
	api.use('webapp');
	api.use('templating', 'client');
	api.use('kadira:flow-router', 'client');

	api.use([
		'ecmascript',
		'coffeescript',
		'underscore',
		'tagt:lib',
		'jquery',
		'tagt:api',
		'tagt:bosonnlp',
		'tagt:swiper',
		'tagt:wangeditor',
		'tagt:ui',
		'tagt:ui-activity',
		'nimble:restivus',
		'percolate:synced-cron',
		'tagt:mobile-detect',
		'tagt:score',
		'tagt:qiniu',
		'sha'
	]);

	
	
	api.addFiles('server/api.coffee', 'server');
	// api.addFiles('server/connectMultiparty.js', 'server');
	api.addFiles('server/startup/startup.coffee', 'server');
	api.addFiles('server/startup/debateTagCron.coffee', 'server');

	api.addFiles('client/lib/collections.coffee', 'client');
	api.addFiles('client/lib/startup.coffee', 'client');
	api.addFiles('client/lib/DebatesManager.coffee', 'client');
	

	api.addFiles('client/route.coffee', 'client');

	api.addFiles('client/views/debate.html', 'client');
	api.addFiles('client/views/debateFlex.html', 'client')
	api.addFiles('client/views/debateProfile.html', 'client');
	api.addFiles('client/views/debateEdit.html', 'client');
	api.addFiles('client/views/debateTag.html', 'client');
	api.addFiles('client/views/debateItem.html', 'client');
	api.addFiles('client/views/debateCateConfirm.html', 'client');
	api.addFiles('client/views/popDebateTagInput.html', 'client');;
	api.addFiles('client/views/debates.html', 'client');
	api.addFiles('client/views/userDebates.html', 'client');
	api.addFiles('client/views/debateType.html', 'client');
	api.addFiles('client/views/typeDebates.html', 'client');
	api.addFiles('client/views/userDebateTag.html', 'client');
	
	api.addFiles('client/views/debate.coffee', 'client');
	api.addFiles('client/views/debateFlex.coffee', 'client');
	api.addFiles('client/views/debateProfile.coffee', 'client');
	api.addFiles('client/views/debateEdit.coffee', 'client');
	api.addFiles('client/views/debateTag.coffee', 'client');
	api.addFiles('client/views/debateItem.coffee', 'client');
	api.addFiles('client/views/debateCateConfirm.coffee', 'client');
	api.addFiles('client/views/popDebateTagInput.coffee', 'client');
	api.addFiles('client/views/debates.coffee', 'client');
	api.addFiles('client/views/userDebates.coffee', 'client');
	api.addFiles('client/views/debateType.coffee', 'client');
	api.addFiles('client/views/typeDebates.coffee', 'client');
	api.addFiles('client/views/userDebateTag.coffee', 'client');

	api.addFiles('client/stylesheets/debate.css', ['client']);

	// api.export('multipart');

});
