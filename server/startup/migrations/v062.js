TAGT.Migrations.add({
	version: 62,
	up: function() {
		TAGT.models.Settings.remove({ _id: 'Atlassian Crowd', type: 'group' });
	}
});
