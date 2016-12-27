Meteor.methods({
	'livechat:addAgent'(username) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:addAgent' });
		}

		if (!username || !_.isString(username)) {
			throw new Meteor.Error('error-invalid-arguments', 'Invalid arguments', { method: 'livechat:addAgent' });
		}

		var user = TAGT.models.Users.findOneByUsername(username, { fields: { _id: 1 } });

		if (!user) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'livechat:addAgent' });
		}

		if (TAGT.authz.addUserRoles(user._id, 'livechat-agent')) {
			TAGT.models.Users.setOperator(user._id, true);
			TAGT.models.Users.setLivechatStatus(user._id, 'available');
			return true;
		}

		return false;
	}
});
