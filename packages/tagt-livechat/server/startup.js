Meteor.startup(() => {
	TAGT.roomTypes.setPublish('l', (code) => {
		return TAGT.models.Rooms.findLivechatByCode(code, {
			name: 1,
			t: 1,
			cl: 1,
			u: 1,
			label: 1,
			usernames: 1,
			v: 1,
			livechatData: 1,
			topic: 1,
			tags: 1,
			sms: 1,
			code: 1,
			open: 1
		});
	});

	TAGT.authz.addRoomAccessValidator(function(room, user) {
		return room.t === 'l' && TAGT.authz.hasPermission(user._id, 'view-livechat-rooms');
	});

	TAGT.callbacks.add('beforeLeaveRoom', function(user, room) {
		if (room.t !== 'l') {
			return user;
		}
		throw new Meteor.Error(TAPi18n.__('You_cant_leave_a_livechat_room_Please_use_the_close_button', {
			lng: user.language || TAGT.settings.get('language') || 'en'
		}));
	}, TAGT.callbacks.priority.LOW);
});
