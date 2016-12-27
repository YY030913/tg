Package.describe({
  name: 'tagt:search',
  version: '0.1.0',
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

  api.use([
    'ecmascript',
    'templating@1.1.5',
    'coffeescript@1.0.11',
    'underscore@1.0.4',
    'tagt:lib',
    'sha@1.0.4'
  ]);

  api.use('kadira:flow-router@2.10.1', 'client');

  api.addFiles('client/views/stageSearch.html', 'client');
  api.addFiles('client/views/stageSearchResult.html', 'client');
  api.addFiles('client/views/stageSearchModal.html', 'client');


  api.addFiles('client/views/stageSearch.coffee', 'client');
  api.addFiles('client/views/stageSearchModal.coffee', 'client');
  api.addFiles('client/views/stageSearchResult.coffee', 'client');


  api.addFiles('client/router.coffee', 'client');
});