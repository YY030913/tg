if (_.isUndefined(TAGT.models.Subscriptions)) {
	TAGT.models.Subscriptions = {};
}

TAGT.models.Subscriptions.isUserInRole = function(userId, roleName, roomId) {
	if (roomId == null) {
		return false;
	}

	var query = {
		rid: roomId,
		roles: roleName
	};

	return !_.isUndefined(this.findOne(query));
};

TAGT.models.Subscriptions.findUsersInRoles = function(roles, scope, options) {
	roles = [].concat(roles);

	var query = {
		roles: { $in: roles }
	};

	if (scope) {
		query.rid = scope;
	}

	var subscriptions = this.find(query).fetch();

	var users = _.compact(_.map(subscriptions, function(subscription) {
		if ('undefined' !== typeof subscription.u && 'undefined' !== typeof subscription.u._id) {
			return subscription.u._id;
		}
	}));

	return TAGT.models.Users.find({ _id: { $in: users } }, options);
};
