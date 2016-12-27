TAGT.Migrations.add({
	version: 43,
	up: function() {
		if (TAGT && TAGT.models && TAGT.models.Permissions) {
			TAGT.models.Permissions.update({ _id: 'pin-message' }, { $addToSet: { roles: 'admin' } });
		}
	}
});
