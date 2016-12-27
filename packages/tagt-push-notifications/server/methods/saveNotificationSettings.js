Meteor.methods({
	saveNotificationSettings: function(rid, field, value) {
		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'saveNotificationSettings' });
		}

		check(rid, String);
		check(field, String);
		check(value, String);

		if (['desktopNotifications', 'mobilePushNotifications', 'emailNotifications', 'unreadAlert'].indexOf(field) === -1) {
			throw new Meteor.Error('error-invalid-settings', 'Invalid settings field', { method: 'saveNotificationSettings' });
		}

		if (['all', 'mentions', 'nothing', 'default'].indexOf(value) === -1) {
			throw new Meteor.Error('error-invalid-settings', 'Invalid settings value', { method: 'saveNotificationSettings' });
		}

		const subscription = TAGT.models.Subscriptions.findOneByRoomIdAndUserId(rid, Meteor.userId());
		if (!subscription) {
			throw new Meteor.Error('error-invalid-subscription', 'Invalid subscription', { method: 'saveNotificationSettings' });
		}

		switch (field) {
			case 'desktopNotifications':
				TAGT.models.Subscriptions.updateDesktopNotificationsById(subscription._id, value);
				break;
			case 'mobilePushNotifications':
				TAGT.models.Subscriptions.updateMobilePushNotificationsById(subscription._id, value);
				break;
			case 'emailNotifications':
				TAGT.models.Subscriptions.updateEmailNotificationsById(subscription._id, value);
				break;
			case 'unreadAlert':
				TAGT.models.Subscriptions.updateUnreadAlertById(subscription._id, value);
				break;
		}

		return true;
	},

	saveDesktopNotificationDuration: function(rid, value) {
		const subscription = TAGT.models.Subscriptions.findOneByRoomIdAndUserId(rid, Meteor.userId());
		if (!subscription) {
			throw new Meteor.Error('error-invalid-subscription', 'Invalid subscription', { method: 'saveDesktopNotificationDuration' });
		}
		TAGT.models.Subscriptions.updateDesktopNotificationDurationById(subscription._id, value);
		return true;
	}
});
