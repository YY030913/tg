TAGT.Migrations.add({
	version: 52,
	up: function() {
		TAGT.models.Users.update({ _id: 'talk get' }, { $addToSet: { roles: 'bot' } });
	}
});
