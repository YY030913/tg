Package.describe({
    name: 'tagt:materialize',
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
    api.versionsFrom('1.4.1');

    api.use('ecmascript');
    api.use([
        'jquery@1.11.4',
        'coffeescript@1.0.11',
        'aldeed:template-extension@4.0.0',
        'momentjs:moment@2.13.1'
    ]);

    api.addAssets([
        'client/stylesheets/font/material-design-icons/Material-Design-Icons.svg',
        'client/stylesheets/font/material-design-icons/Material-Design-Icons.ttf',
        'client/stylesheets/font/material-design-icons/Material-Design-Icons.woff',
        'client/stylesheets/font/material-design-icons/Material-Design-Icons.woff2',
        'client/stylesheets/font/roboto/Roboto-Bold.ttf',
        'client/stylesheets/font/roboto/Roboto-Bold.woff',
        'client/stylesheets/font/roboto/Roboto-Bold.woff2',
        'client/stylesheets/font/roboto/Roboto-Light.ttf',
        'client/stylesheets/font/roboto/Roboto-Light.woff',
        'client/stylesheets/font/roboto/Roboto-Light.woff2',
        'client/stylesheets/font/roboto/Roboto-Medium.ttf',
        'client/stylesheets/font/roboto/Roboto-Medium.woff',
        'client/stylesheets/font/roboto/Roboto-Medium.woff2',
        'client/stylesheets/font/roboto/Roboto-Regular.ttf',
        'client/stylesheets/font/roboto/Roboto-Regular.woff',
        'client/stylesheets/font/roboto/Roboto-Regular.woff2',
        'client/stylesheets/font/roboto/Roboto-Thin.ttf',
        'client/stylesheets/font/roboto/Roboto-Thin.woff',
        'client/stylesheets/font/roboto/Roboto-Thin.woff2'
    ], ['client']);

    api.addFiles([
        'client/stylesheets/js/hammer.js',
        
        'client/stylesheets/js/materialize.min.js',
        'client/stylesheets/js/plugins/animate-css/animate.css',

        'client/stylesheets/css/materialize.min.css',
        'client/stylesheets/css/style.min.css',
        'client/stylesheets/css/custom/custom.min.css',
        'client/stylesheets/css/layouts/page-center.css',
        'client/stylesheets/css/layouts/style-fullscreen.css',
        'client/stylesheets/css/layouts/style-horizontal.css',

        'client/stylesheets/js/plugins.min.js',

        'client/stylesheets/js/wavesEffect.js'

    ], 'client');
});