TAGT.Migrations.add({
	version: 51,
	up: function() {
		TAGT.models.Rooms.find({ t: 'l', 'v.token': { $exists: true }, label: { $exists: false }}).forEach(function(room) {
			var user = TAGT.models.Users.findOne({ 'profile.token': room.v.token });
			if (user) {
				TAGT.models.Rooms.update({ _id: room._id }, {
					$set: {
						label: user.name || user.username,
						'v._id': user._id
					}
				});
				TAGT.models.Subscriptions.update({ rid: room._id }, {
					$set: {
						name: user.name || user.username
					}
				}, { multi: true });
			}
		});
	}
});
