TAGT.Migrations.add({
	version: 37,
	up: function() {
		if (TAGT && TAGT.models && TAGT.models.Permissions) {

			// Find permission add-user (changed it to create-user)
			var addUserPermission = TAGT.models.Permissions.findOne('add-user');

			if (addUserPermission) {
				TAGT.models.Permissions.upsert({ _id: 'create-user' }, { $set: { roles: addUserPermission.roles } });
				TAGT.models.Permissions.remove({ _id: 'add-user' });
			}
		}
	}
});
