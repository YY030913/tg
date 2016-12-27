Meteor.publish('livechat:officeHour', function() {
	if (!TAGT.authz.hasPermission(this.userId, 'view-l-room')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:agents' }));
	}

	return TAGT.models.LivechatOfficeHour.find();
});