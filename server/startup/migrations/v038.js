TAGT.Migrations.add({
	version: 38,
	up: function() {
		if (TAGT && TAGT.settings && TAGT.settings.get) {
			var allowPinning = TAGT.settings.get('Message_AllowPinningByAnyone');

			// If public pinning was allowed, add pinning permissions to 'users', else leave it to 'owners' and 'moderators'
			if (allowPinning) {
				if (TAGT.models && TAGT.models.Permissions) {
					TAGT.models.Permissions.update({ _id: 'pin-message' }, { $addToSet: { roles: 'user' } });
				}
			}
		}
	}
});
