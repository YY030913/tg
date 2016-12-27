/* eslint new-cap: [2, {"capIsNewExceptions": ["Match.ObjectIncluding", "Match.Optional"]}] */

Meteor.methods({
	'livechat:saveInfo': function(guestData, roomData) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'view-l-room')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:saveInfo' });
		}

		check(guestData, Match.ObjectIncluding({
			_id: String,
			name: Match.Optional(String),
			email: Match.Optional(String),
			phone: Match.Optional(String)
		}));

		check(roomData, Match.ObjectIncluding({
			_id: String,
			topic: Match.Optional(String),
			tags: Match.Optional(String)
		}));

		const ret = TAGT.Livechat.saveGuest(guestData) && TAGT.Livechat.saveRoomInfo(roomData, guestData);

		Meteor.defer(() => {
			TAGT.callbacks.run('livechat.saveInfo', TAGT.models.Rooms.findOneById(roomData._id));
		});

		return ret;
	}
});
