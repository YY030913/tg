TAGT.Migrations.add({
	version: 46,
	up: function() {
		if (TAGT && TAGT.models && TAGT.models.Users) {
			TAGT.models.Users.update({ type: { $exists: false } }, { $set: { type: 'user' } }, { multi: true });
		}
	}
});
