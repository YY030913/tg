Package.describe({
  name: 'tagt:bosonnlp',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

Npm.depends({
  'bosonnlp':'0.0.9'
});

Package.onUse(function(api) {
  api.use('ecmascript');
  api.versionsFrom('1.4.0.1');
  // api.use(['cosmos:browserify@0.10.0'], 'client');

  // api.addFiles('client.browserify.js', 'client');
  // api.export('bosonnlp', 'client');
});

