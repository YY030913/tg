Package.describe({
  name: 'tagt:audioplayer',
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
  api.versionsFrom('1.4.2.3');
  api.use('jquery');
  api.use('ecmascript');
  api.addFiles(['socialite.js', 'viewport.js', 'audioplayer.js', 'audioplayer.css'], 'client');
});
