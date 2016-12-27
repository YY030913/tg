Package.describe({
  name: 'tagt:tag',
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
  api.versionsFrom('1.2.1');

  api.use('coffeescript@1.0.11');
  api.use('ecmascript');
  api.use('random@1.0.5');
  api.use('tagt:lib');
  api.use('tagt:ui-debate');
  api.use('reactive-var@1.0.6');
  api.use('tagt:authorization');
  api.use('tracker@1.0.9');

  api.use('kadira:flow-router@2.10.1', 'client');
  api.use('templating@1.1.5', 'client');

  api.addFiles('server/startup.coffee','server');
  api.addFiles('server/functions/canAccessTag.js','server');

  api.addFiles('client/router.coffee','client');

  api.addFiles('client/lib/TagManager.coffee','client');
  api.addFiles('client/lib/openTag.coffee','client');
  api.addFiles('client/lib/collection.coffee','client');
  
  api.addFiles('client/views/roleSearch.html','client');
  api.addFiles('client/views/tagSearch.html','client');
  api.addFiles('client/views/tags.html','client');
  api.addFiles('client/views/tagsRole.html','client');
  api.addFiles('client/views/tagNotFound.html','client');
  api.addFiles('client/views/popRoleInput.html','client');


  api.addFiles('client/views/tags.coffee','client');
  api.addFiles('client/views/tagsRole.coffee','client');
  api.addFiles('client/views/tagNotFound.coffee','client');
  api.addFiles('client/views/popRoleInput.coffee','client');

});