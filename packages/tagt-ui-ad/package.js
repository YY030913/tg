Package.describe({
  name: 'tagt:ui-ad',
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
  api.use([
    'ecmascript',
    'templating@1.1.5',
    'coffeescript@1.0.11',
    'underscore@1.0.4',
    'tagt:lib',
    'tagt:ui',
    'sha@1.0.4'
  ]);

  api.use('kadira:flow-router@2.10.1', 'client');

  api.addFiles('server/startup.coffee', 'server');
  
  api.addFiles('client/router.coffee', 'client');

  api.addFiles('client/views/adBanner.html', 'client');
  api.addFiles('client/views/adEdit.html', 'client');
  api.addFiles('client/views/ads.html', 'client');

  api.addFiles('client/views/adBanner.coffee', 'client');
  api.addFiles('client/views/adEdit.coffee', 'client');
  api.addFiles('client/views/ads.coffee', 'client');

});
