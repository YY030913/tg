TAGT.Migrations.add({
	version: 50,
	up: function() {
		TAGT.models.Subscriptions.tryDropIndex('u._id_1_name_1_t_1');
		TAGT.models.Subscriptions.tryEnsureIndex({ 'u._id': 1, 'name': 1, 't': 1 });
	}
});
