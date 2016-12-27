Meteor.publish('livechat:departmentAgents', function(departmentId) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:departmentAgents' }));
	}

	if (!TAGT.authz.hasPermission(this.userId, 'view-livechat-rooms')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:departmentAgents' }));
	}

	return TAGT.models.LivechatDepartmentAgents.find({ departmentId: departmentId });
});
