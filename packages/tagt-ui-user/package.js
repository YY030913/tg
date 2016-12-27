Package.describe({
  name: 'tagt:ui-user',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4.0.1');
  api.use('reactive-var@1.0.6');
  api.use('tracker@1.0.9');
  api.use('templating@1.1.5', 'client');
  api.use('kadira:flow-router@2.10.1', 'client');

  api.use([
    'ecmascript',
    'coffeescript@1.0.11',
    'underscore@1.0.4',
    'tagt:lib',
    'jquery@1.11.4',
    'tagt:api',
    'tagt:ui',
    'tagt:authorization',
    'nimble:restivus@0.8.10',
    'percolate:synced-cron',
    'sha@1.0.4'
  ]);
  
  api.addFiles('client/lib/route.coffee', 'client');
  api.addFiles('client/lib/startup.coffee', 'client');

  api.addFiles('client/views/userProfile.html', 'client');
  api.addFiles('client/views/avatarList.html', 'client');
  api.addFiles('client/views/userList.html', 'client');


  api.addFiles('client/views/userProfile.coffee', 'client');
  api.addFiles('client/views/avatarList.coffee', 'client');
  api.addFiles('client/views/userList.coffee', 'client');

  api.addFiles('server/startup/startup.coffee', 'server');
  api.addFiles('server/publications/userProfile.coffee', 'server');
});
