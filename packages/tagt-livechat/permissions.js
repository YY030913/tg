Meteor.startup(() => {
	var roles = _.pluck(TAGT.models.Roles.find().fetch(), 'name');
	if (roles.indexOf('livechat-agent') === -1) {
		TAGT.models.Roles.createOrUpdate('livechat-agent');
	}
	if (roles.indexOf('livechat-manager') === -1) {
		TAGT.models.Roles.createOrUpdate('livechat-manager');
	}
	if (roles.indexOf('livechat-guest') === -1) {
		TAGT.models.Roles.createOrUpdate('livechat-guest');
	}
	if (TAGT.models && TAGT.models.Permissions) {
		TAGT.models.Permissions.createOrUpdate('view-l-room', ['livechat-agent', 'livechat-manager', 'admin']);
		TAGT.models.Permissions.createOrUpdate('view-livechat-manager', ['livechat-manager', 'admin']);
		TAGT.models.Permissions.createOrUpdate('view-livechat-rooms', ['livechat-manager', 'admin']);
		TAGT.models.Permissions.createOrUpdate('close-livechat-room', ['livechat-agent', 'livechat-manager', 'admin']);
		TAGT.models.Permissions.createOrUpdate('close-others-livechat-room', ['livechat-manager', 'admin']);
	}
});
