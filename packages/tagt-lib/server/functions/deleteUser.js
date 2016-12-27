/* globals TAGT */
TAGT.deleteUser = function(userId) {
	const user = TAGT.models.Users.findOneById(userId);

	TAGT.models.Messages.removeByUserId(userId); // Remove user messages
	TAGT.models.Subscriptions.findByUserId(userId).forEach((subscription) => {
		let room = TAGT.models.Rooms.findOneById(subscription.rid);
		if (room) {
			if (room.t !== 'c' && room.usernames.length === 1) {
				TAGT.models.Rooms.removeById(subscription.rid); // Remove non-channel rooms with only 1 user (the one being deleted)
			}
			if (room.t === 'd') {
				TAGT.models.Subscriptions.removeByRoomId(subscription.rid);
				TAGT.models.Messages.removeByRoomId(subscription.rid);
			}
		}
	});

	TAGT.models.Subscriptions.removeByUserId(userId); // Remove user subscriptions
	TAGT.models.Rooms.removeByTypeContainingUsername('d', user.username); // Remove direct rooms with the user
	TAGT.models.Rooms.removeUsernameFromAll(user.username); // Remove user from all other rooms

	// removes user's avatar
	if (user.avatarOrigin === 'upload' || user.avatarOrigin === 'url') {
		TAGTFileAvatarInstance.deleteFile(encodeURIComponent(user.username + '.jpg'));
	}

	TAGT.models.Users.removeById(userId); // Remove user from users database
};
