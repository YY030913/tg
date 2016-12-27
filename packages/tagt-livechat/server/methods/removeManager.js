Meteor.methods({
	'livechat:removeManager'(username) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:removeManager' });
		}

		check(username, String);

		var user = TAGT.models.Users.findOneByUsername(username, { fields: { _id: 1 } });

		if (!user) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'livechat:removeManager' });
		}

		return TAGT.authz.removeUserFromRoles(user._id, 'livechat-manager');
	}
});
