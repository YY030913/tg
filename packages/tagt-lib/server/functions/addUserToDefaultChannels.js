TAGT.addUserToDefaultChannels = function(user, silenced) {
	TAGT.callbacks.run('beforeJoinDefaultChannels', user);
	let defaultRooms = TAGT.models.Rooms.findByDefaultAndTypes(true, ['c', 'p'], {fields: {usernames: 0}}).fetch();
	defaultRooms.forEach((room) => {

		// put user in default rooms
		TAGT.models.Rooms.addUsernameById(room._id, user.username);

		if (!TAGT.models.Subscriptions.findOneByRoomIdAndUserId(room._id, user._id)) {

			// Add a subscription to this user
			TAGT.models.Subscriptions.createWithRoomAndUser(room, user, {
				ts: new Date(),
				open: true,
				alert: true,
				unread: 1
			});

			// Insert user joined message
			if (!silenced) {
				TAGT.models.Messages.createUserJoinWithRoomIdAndUser(room._id, user);
			}
		}
	});
};
