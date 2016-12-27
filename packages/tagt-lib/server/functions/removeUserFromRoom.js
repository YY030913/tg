TAGT.removeUserFromRoom = function(rid, user) {
	let room = TAGT.models.Rooms.findOneById(rid);

	if (room) {
		TAGT.callbacks.run('beforeLeaveRoom', user, room);
		TAGT.models.Rooms.removeUsernameById(rid, user.username);

		if (room.usernames.indexOf(user.username) !== -1) {
			let removedUser = user;
			TAGT.models.Messages.createUserLeaveWithRoomIdAndUser(rid, removedUser);
		}

		if (room.t === 'l') {
			TAGT.models.Messages.createCommandWithRoomIdAndUser('survey', rid, user);
		}

		TAGT.models.Subscriptions.removeByRoomIdAndUserId(rid, user._id);

		Meteor.defer(function() {
			TAGT.callbacks.run('afterLeaveRoom', user, room);
		});
	}
};
