Meteor.methods({
	'livechat:removeTrigger'(/*trigger*/) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:removeTrigger' });
		}

		return TAGT.models.LivechatTrigger.removeAll();
	}
});
