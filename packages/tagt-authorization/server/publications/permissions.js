Meteor.methods({
	'permissions/get'() {
		this.unblock();
		return TAGT.models.Permissions.find().fetch();
	},

	'permissions/sync'(updatedAt) {
		this.unblock();

		return TAGT.models.Permissions.dinamicFindChangesAfter('find', updatedAt);
	}
});


TAGT.models.Permissions.on('change', (type, ...args) => {
	const records = TAGT.models.Permissions.getChangedRecords(type, args[0]);

	for (const record of records) {
		TAGT.Notifications.notifyAll('permissions-changed', type, record);
	}
});
