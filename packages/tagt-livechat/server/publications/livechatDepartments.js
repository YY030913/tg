Meteor.publish('livechat:departments', function(_id) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:agents' }));
	}

	if (!TAGT.authz.hasPermission(this.userId, 'view-l-room')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:agents' }));
	}

	if (_id !== undefined) {
		return TAGT.models.LivechatDepartment.findByDepartmentId(_id);
	} else {
		return TAGT.models.LivechatDepartment.find();
	}

});
