/* globals Inject */

Inject.rawBody('page-loading', ``);


TAGT.settings.get('theme-color-primary-background-color', function(key, value) {
	if (value) {
		Inject.rawHead('theme-color-primary-background-color', `<style>body { background-color: ${value};}</style>`);
	} else {
		Inject.rawHead('theme-color-primary-background-color', '<style>body { background-color: #04436a;}</style>');
	}
});

TAGT.settings.get('theme-color-tertiary-background-color', function(key, value) {
	if (value) {
		Inject.rawHead('theme-color-tertiary-background-color', `<style>.loading > div { background-color: ${value};}</style>`);
	} else {
		Inject.rawHead('theme-color-tertiary-background-color', '<style>.loading > div { background-color: #cccccc;}</style>');
	}
});

TAGT.settings.get('Site_Url', function() {
	Meteor.defer(function() {
		let baseUrl;
		if (__meteor_runtime_config__.ROOT_URL_PATH_PREFIX && __meteor_runtime_config__.ROOT_URL_PATH_PREFIX.trim() !== '') {
			baseUrl = __meteor_runtime_config__.ROOT_URL_PATH_PREFIX;
		} else {
			baseUrl = '/';
		}
		if (/\/$/.test(baseUrl) === false) {
			baseUrl += '/';
		}
		Inject.rawHead('base', `<base href="${baseUrl}">`);
	});
});

TAGT.settings.get('GoogleSiteVerification_id', function(key, value) {
	if (value) {
		Inject.rawHead('google-site-verification', `<meta name="google-site-verification" content="${value}" />`);
	} else {
		Inject.rawHead('google-site-verification', '');
	}
});
