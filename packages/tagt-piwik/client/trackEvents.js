//Trigger the trackPageView manually as the page views don't seem to be tracked
FlowRouter.triggers.enter([(route) => {
	if (window._paq) {
		let http = location.protocol;
		let slashes = http.concat('//');
		let host = slashes.concat(window.location.hostname);

		window._paq.push(['setCustomUrl', host + route.path]);
		window._paq.push(['trackPageView']);
	}
}]);

//Login page has manual switches
TAGT.callbacks.add('loginPageStateChange', (state) => {
	if (window._paq) {
		window._paq.push(['trackEvent', 'Navigation', 'Login Page State Change', state]);
	}
});

//Messsages
TAGT.callbacks.add('afterSaveMessage', (message) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_messages')) {
		let room = ChatRoom.findOne({ _id: message.rid });
		window._paq.push(['trackEvent', 'Message', 'Send', room.name + ' (' + room._id + ')' ]);
	}
}, 2000, 'trackEvents');

//Rooms
TAGT.callbacks.add('afterCreateChannel', (room) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_rooms')) {
		window._paq.push(['trackEvent', 'Room', 'Create', room.name + ' (' + room._id + ')' ]);
	}
});

TAGT.callbacks.add('roomNameChanged', (room) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_rooms')) {
		window._paq.push(['trackEvent', 'Room', 'Changed Name', room.name + ' (' + room._id + ')' ]);
	}
});

TAGT.callbacks.add('roomTopicChanged', (room) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_rooms')) {
		window._paq.push(['trackEvent', 'Room', 'Changed Topic', room.name + ' (' + room._id + ')' ]);
	}
});

TAGT.callbacks.add('roomTypeChanged', (room) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_rooms')) {
		window._paq.push(['trackEvent', 'Room', 'Changed Room Type', room.name + ' (' + room._id + ')' ]);
	}
});

TAGT.callbacks.add('archiveRoom', (room) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_rooms')) {
		window._paq.push(['trackEvent', 'Room', 'Archived', room.name + ' (' + room._id + ')' ]);
	}
});

TAGT.callbacks.add('unarchiveRoom', (room) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_rooms')) {
		window._paq.push(['trackEvent', 'Room', 'Unarchived', room.name + ' (' + room._id + ')' ]);
	}
});

//Users
//Track logins and associate user ids with piwik
(() => {
	let oldUserId = null;

	Meteor.autorun(() => {
		let newUserId = Meteor.userId();
		if (oldUserId === null && newUserId) {
			if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
				window._paq.push(['trackEvent', 'User', 'Login', newUserId ]);
				window._paq.push(['setUserId', newUserId]);
			}
		} else if (newUserId === null && oldUserId) {
			if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
				window._paq.push(['trackEvent', 'User', 'Logout', oldUserId ]);
			}
		}
		oldUserId = Meteor.userId();
	});
})();

TAGT.callbacks.add('userRegistered', () => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
		window._paq.push(['trackEvent', 'User', 'Registered']);
	}
});

TAGT.callbacks.add('usernameSet', () => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
		window._paq.push(['trackEvent', 'User', 'Username Set']);
	}
});

TAGT.callbacks.add('userPasswordReset', () => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
		window._paq.push(['trackEvent', 'User', 'Reset Password']);
	}
});

TAGT.callbacks.add('userConfirmationEmailRequested', () => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
		window._paq.push(['trackEvent', 'User', 'Confirmation Email Requested']);
	}
});

TAGT.callbacks.add('userForgotPasswordEmailRequested', () => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
		window._paq.push(['trackEvent', 'User', 'Forgot Password Email Requested']);
	}
});

TAGT.callbacks.add('userStatusManuallySet', (status) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
		window._paq.push(['trackEvent', 'User', 'Status Manually Changed', status]);
	}
});

TAGT.callbacks.add('userAvatarSet', (service) => {
	if (window._paq && TAGT.settings.get('PiwikAnalytics_features_users')) {
		window._paq.push(['trackEvent', 'User', 'Avatar Changed', service]);
	}
});
