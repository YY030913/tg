Meteor.methods({
	'livechat:saveTrigger'(trigger) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'view-livechat-manager')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:saveTrigger' });
		}

		return TAGT.models.LivechatTrigger.save(trigger);
	}
});
