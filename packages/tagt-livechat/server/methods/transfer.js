/* eslint new-cap: [2, {"capIsNewExceptions": ["Match.Optional"]}] */
Meteor.methods({
	'livechat:transfer'(transferData) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'view-l-room')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:transfer' });
		}

		check(transferData, {
			roomId: String,
			userId: Match.Optional(String),
			deparmentId: Match.Optional(String)
		});

		const room = TAGT.models.Rooms.findOneById(transferData.roomId);

		const guest = TAGT.models.Users.findOneById(room.v._id);

		const user = Meteor.user();

		if (room.usernames.indexOf(user.username) === -1) {
			throw new Meteor.Error('error-not-authorized', 'Not authorized', { method: 'livechat:transfer' });
		}

		return TAGT.Livechat.transfer(room, guest, transferData);
	}
});
