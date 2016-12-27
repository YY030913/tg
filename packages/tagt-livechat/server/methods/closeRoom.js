Meteor.methods({
	'livechat:closeRoom'(roomId, comment) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'close-livechat-room')) {
			throw new Meteor.Error('error-not-authorized', 'Not authorized', { method: 'livechat:closeRoom' });
		}

		const room = TAGT.models.Rooms.findOneById(roomId);

		const user = Meteor.user();

		if (room.usernames.indexOf(user.username) === -1 && !TAGT.authz.hasPermission(Meteor.userId(), 'close-others-livechat-room')) {
			throw new Meteor.Error('error-not-authorized', 'Not authorized', { method: 'livechat:closeRoom' });
		}

		return TAGT.Livechat.closeRoom({
			user: user,
			room: room,
			comment: comment
		});
	}
});
