Package.describe({
  name: 'tagt:wangeditor',
  version: '0.0.1',
  // Brief, one-line summary of the package.
  summary: '',
  // URL to the Git repository containing the source code for this package.
  git: '',
  // By default, Meteor will default to using README.md for documentation.
  // To avoid submitting documentation, set this field to null.
  documentation: 'README.md'
});

// Specify npm modules
Npm.depends({
    // 'upper-case':'1.1.2'
    // 'wangeditor':'2.1.12',
    // "exposify": "0.4.3"
    'qiniu': '6.1.9'
});


Package.onUse(function(api) {
  api.versionsFrom('1.2.1');
  
  api.use('ecmascript');
  api.use([
    'tagt:qiniu',
    'jquery@1.11.4'
  ], 'client');

  api.addAssets('dist/fonts/icomoon.eot', 'client');
  api.addAssets('dist/fonts/icomoon.svg', 'client');
  api.addAssets('dist/fonts/icomoon.ttf', 'client');
  api.addAssets('dist/fonts/icomoon.woff', 'client');

  api.addAssets('dist/mobile-fonts/icomoon.eot', 'client');
  api.addAssets('dist/mobile-fonts/icomoon.svg', 'client');
  api.addAssets('dist/mobile-fonts/icomoon.ttf', 'client');
  api.addAssets('dist/mobile-fonts/icomoon.woff', 'client');

  api.addFiles([
    'dist/js/wangEditor.js',
    'dist/wangEditor.css',
  ], 'client');

  api.addFiles([
    'dist/wangEditor-mobile.css',
    'dist/js/lib/zepto.js',
    'dist/js/lib/zepto.touch.js',
    'dist/js/wangEditor-mobile.js'
  ], 'client');

});

