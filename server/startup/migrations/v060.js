TAGT.Migrations.add({
	version: 60,
	up: function() {
		let subscriptions = TAGT.models.Subscriptions.find({ $or: [ { name: { $exists: 0 } }, { name: { $not: { $type: 2 } } } ] }).fetch();
		if (subscriptions && subscriptions.length > 0) {
			TAGT.models.Subscriptions.remove({ _id: { $in: _.pluck(subscriptions, '_id') } });
		}

		subscriptions = TAGT.models.Subscriptions.find().forEach(function(subscription) {
			let user = TAGT.models.Users.findOne({ _id: subscription && subscription.u && subscription.u._id });
			if (!user) {
				TAGT.models.Subscriptions.remove({ _id: subscription._id });
			}
		});
	}
});
