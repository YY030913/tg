/**
 * Publish logged-in user's roles so client-side checks can work.
 */
Meteor.publish('scopedRoles', function(scope) {
	if (!this.userId || _.isUndefined(TAGT.models[scope]) || !_.isFunction(TAGT.models[scope].findRolesByUserId)) {
		this.ready();
		return;
	}

	return TAGT.models[scope].findRolesByUserId(this.userId);
});
