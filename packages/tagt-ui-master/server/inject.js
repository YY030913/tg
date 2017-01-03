/* globals Inject */

Inject.rawBody('page-loading', `
<style>

.full-page {
	background: url('https://caoliao.net.cn/images/full-bg.jpeg');
	background-size: 100% 100%;
}

.loading-loader {
	line-height: 80px;
}
.loading-image {
	background: url(https://caoliao.net.cn/images/logo/58x58.png);
	background-size: 100% 100%;
	position: absolute;
	top: 60px;
	left: 35%;
	width: 36px;
	height: 36px;
	margin: -40px 0 0 -40px;
	-webkit-animation: spin 3s ease-in-out infinite;
	-moz-animation: spin 3s ease-in-out infinite;
	animation: spin 3s ease-in-out infinite;
}
.loading-text {
	text-align: center;
}

.loading {
	top: 0;
	right: 0;
	bottom: 0;
	left: 0;
	display: flex;
	align-items: center;
	position: absolute;
	justify-content: center;
	text-align: center;
}
.loading > div {
	width: 10px;
	height: 10px;
	margin: 2px;
	border-radius: 100%;
	display: inline-block;
	-webkit-animation: loading-bouncedelay 1.4s infinite ease-in-out both;
	animation: loading-bouncedelay 1.4s infinite ease-in-out both;
}
.loading .bounce1 {
	-webkit-animation-delay: -0.32s;
	animation-delay: -0.32s;
}
.loading .bounce2 {
	-webkit-animation-delay: -0.16s;
	animation-delay: -0.16s;
}
@-webkit-keyframes loading-bouncedelay {
	0%, 80%, 100% { -webkit-transform: scale(0) }
	40% { -webkit-transform: scale(1.0) }
}
@keyframes loading-bouncedelay {
	0%, 80%, 100% { transform: scale(0); }
	40% { transform: scale(1.0); }
}
</style>
<div id="initial-page-loading" class="page-loading">
	<div class="loading">
		<div class="bounce1"></div>
		<div class="bounce2"></div>
		<div class="bounce3"></div>
	</div>
</div>`);


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
