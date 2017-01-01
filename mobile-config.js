// This section sets up some basic app metadata,
// the entire section is optional.
App.info({
	id: 'cn.net.caoliao',
	name: 'talk get',
	description: 'feed for brain',
	author: 'Matt Development Group',
	email: 'contact@caoliao.net.cn',
	website: 'https://caoliao.net.cn'
});

// Set up resources such as icons and launch screens.
App.icons({
	// 'iphone': 'public/images/favicon/60x60.png',
	'iphone_2x': 'public/images/favicon/120x120.png', // (120x120)
	'iphone_3x': 'public/images/favicon/180x180.png', // (180x180)
	// 'ipad': 'public/images/favicon/76x76.png', //(76x76)
	'ipad_2x': 'public/images/favicon/152x152.png', // (152x152)
	// 'ipad_pro': 'public/images/favicon/167x167.png',// (167x167)
	// 'ios_settings': 'public/images/favicon/29x29.png',// (29x29)
	// 'ios_settings_2x': 'public/images/favicon/58x58.png',// (58x58)
	// 'ios_settings_3x': 'public/images/favicon/87x87.png',// (87x87)
	// 'ios_spotlight': 'public/images/favicon/40x40.png',// (40x40)
	// 'ios_spotlight_2x': 'public/images/favicon/80x80.png',// (80x80)
	'android_mdpi': 'public/images/favicon/48x48.png', // (48x48)
	'android_hdpi': 'public/images/favicon/72x72.png', // (72x72)
	'android_xhdpi': 'public/images/favicon/96x96.png', // (96x96)
	'android_xxhdpi': 'public/images/favicon/144x144.png', // (144x144)
	'android_xxxhdpi': 'public/images/favicon/192x192.png' // (192x192)
		// ... more screen sizes and platforms ...
});

App.launchScreens({
	// 'iphone': 'splash/Default~iphone.png',
	'iphone_2x': 'public/images/launchScreens/640x960.png', //(640x960)
	'iphone5': 'public/images/launchScreens/640x1136.png', //(640x1136)
	'iphone6': 'public/images/launchScreens/750x1334.png', //(750x1334)
	'iphone6p_portrait': 'public/images/launchScreens/1242x2208.png', //(1242x2208)
	'iphone6p_landscape': 'public/images/launchScreens/2208x1242.png', //(2208x1242)
	'ipad_portrait': 'public/images/launchScreens/768x1024.png', //(768x1024)
	// 'ipad_portrait_2x': 'public/images/launchScreens/1536x2048.png',//(1536x2048)
	'ipad_landscape': 'public/images/launchScreens/1024x768.png', //(1024x768)
	'ipad_landscape_2x': 'public/images/launchScreens/2048x1536.png', //(2048x1536)
	'android_mdpi_portrait': 'public/images/launchScreens/320x470.png', //(320x470)
	'android_mdpi_landscape': 'public/images/launchScreens/470x320.png', //(470x320)
	// 'android_hdpi_portrait': 'public/images/launchScreens/480x640.png',//  (480x640)
	'android_hdpi_landscape': 'public/images/launchScreens/640x480.png', // (640x480)
	'android_xhdpi_portrait': 'public/images/launchScreens/720x960.png', // (720x960)
	'android_xhdpi_landscape': 'public/images/launchScreens/960x720.png' // (960x720)
		// 'android_xxhdpi_portrait': 'public/images/launchScreens/1080x1440.png',// (1080x1440)
		// 'android_xxhdpi_landscape': 'public/images/launchScreens/1440x1080.png'// (1440x1080)
		// ... more screen sizes and platforms ...
});

// Make the app fullscreen
App.setPreference('fullscreen', 'false');
// Set PhoneGap/Cordova preferences

// App.setPreference("wechatappid", "wx9b12e0ff1b927cef");

App.configurePlugin('cordova-plugin-wechat', {
	"wechatappid": 'wx96f86a95cb3e67f1',
	"WECHATAPPID": 'wx96f86a95cb3e67f1'
});

App.configurePlugin('cordova-plugin-googleplus', {
	'REVERSED_CLIENT_ID': 'com.googleusercontent.apps.282710845697-ev3rm6arn07lmsh83lgpgasq62fmatlt'
});

App.configurePlugin('cordova-plugin-facebook4', {
	'APP_ID': '366939546998671',
	'APP_NAME': 'talk get'
});

App.configurePlugin('mp-cordova-plugin-facebook', {
	'APP_ID': '366939546998671',
	'APP_NAME': 'talk get'
});


App.configurePlugin('cordova-plugin-facebook', {
	'FACEBOOK_APP_ID': '366939546998671',
	'FACEBOOK_DISPLAY_NAME': 'talk get'
});


App.configurePlugin('phonegap-plugin-push', {
	SENDER_ID: "282710845697"
});



App.setPreference('BackgroundColor', "#404461");
App.setPreference('HideKeyboardFormAccessoryBar', true);
App.setPreference('Orientation', 'default');
App.setPreference('Orientation', 'all', 'ios');

App.accessRule("*");
App.accessRule("http://localhost");
App.accessRule("http://google.com")
App.accessRule("https://google.com")
App.accessRule("http://maps.google.com")
App.accessRule('data:*', {
	type: 'navigation'
});

App.accessRule('https://www.caoliao.net.cn');
App.accessRule('https://caoliao.net.cn');

App.accessRule('http://api.segment.io/*');
App.accessRule('https://enginex.kadira.io/*');
App.accessRule('https://fonts.googleapis.com/*');
App.accessRule('https://fonts.gstatic.com/*');
App.accessRule('https://lh3.googleusercontent.com/*');
App.accessRule('https://quasar.meteor.com/*');
App.accessRule('blob:*');


// Social sharing
App.accessRule('*://*.facebook.com/*');
App.accessRule('*://*.fbcdn.net/*');
App.accessRule('*://*.gmail.com/*');
App.accessRule('*://*.google.com/*');
App.accessRule('*://*.linkedin.com/*');
App.accessRule('*://*.pinterest.com/*');
App.accessRule('*://*.twitter.com/*');

App.accessRule('mailto:*');
App.accessRule('sms:*');