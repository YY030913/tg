TAGT.Migrations.add({
	version: 61,
	up: function() {
		TAGT.models.Users.find({ active: false }).forEach(function(user) {
			TAGT.models.Subscriptions.setArchivedByUsername(user.username, true);
		});
	}
});
