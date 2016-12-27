Package.describe({
  name: 'tagt:qiniu',
  version: '0.0.1',
  summary: 'qiniu upload',
  git: '',
  documentation: 'README.md'
});


// Npm.depends({
//   'qiniu': '6.1.9'
// });

Package.onUse(function(api) {
  api.versionsFrom('1.2.1');

  api.use('ecmascript');
  api.use([
    'underscore@1.0.4',
    'jquery@1.11.4'
  ], ['server']);

  // api.use(['cosmos:browserify@0.9.3'], 'client');

  api.addFiles([
      // 'package.browserify.js',           // browserify file
      // 'lib/qiniu-node-sdk.js',
      // 'package.browserify.options.json'
      ], ['server']);

  api.addFiles([
      'lib/qiniu.js',
      'lib/plupload/moxie.js',
      'lib/plupload/plupload.dev.js',
      'lib/QiniuJsSDK.js'
      ], ['client']);

  // api.export('qiniu', 'server');
  api.export('Qiniu', 'client');

});