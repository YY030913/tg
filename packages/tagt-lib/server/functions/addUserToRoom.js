TAGT.addUserToRoom = function(rid, user, inviter, silenced) {
	let now = new Date();
	let room = TAGT.models.Rooms.findOneById(rid);

	// Check if user is already in room
	let subscription = TAGT.models.Subscriptions.findOneByRoomIdAndUserId(rid, user._id);
	if (subscription) {
		return;
	}

	if (room.t === 'c') {
		TAGT.callbacks.run('beforeJoinRoom', user, room);
	}

	var muted = room.ro && !TAGT.authz.hasPermission(user._id, 'post-readonly');
	TAGT.models.Rooms.addUsernameById(rid, user.username, muted);
	TAGT.models.Subscriptions.createWithRoomAndUser(room, user, {
		ts: now,
		open: true,
		alert: true,
		unread: 1
	});

	if (!silenced) {
		if (inviter) {
			TAGT.models.Messages.createUserAddedWithRoomIdAndUser(rid, user, {
				ts: now,
				u: {
					_id: inviter._id,
					username: inviter.username
				}
			});
		} else {
			TAGT.models.Messages.createUserJoinWithRoomIdAndUser(rid, user, { ts: now });
		}
	}

	if (room.t === 'c') {
		Meteor.defer(function() {
			TAGT.callbacks.run('afterJoinRoom', user, room);
		});
	}

	return true;
};
