TAGT.Migrations.add({
	version: 41,
	up: function() {
		if (TAGT && TAGT.models && TAGT.models.Users) {
			TAGT.models.Users.update({ bot: true }, { $set: { type: 'bot' } }, { multi: true });
			TAGT.models.Users.update({ 'profile.guest': true }, { $set: { type: 'visitor' } }, { multi: true });
			TAGT.models.Users.update({ type: { $exists: false } }, { $set: { type: 'user' } }, { multi: true });
		}
	}
});
