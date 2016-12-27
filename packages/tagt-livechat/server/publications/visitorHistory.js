Meteor.publish('livechat:visitorHistory', function({ rid: roomId }) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorHistory' }));
	}

	if (!TAGT.authz.hasPermission(this.userId, 'view-l-room')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorHistory' }));
	}

	var room = TAGT.models.Rooms.findOneById(roomId);

	const user = TAGT.models.Users.findOneById(this.userId);

	if (room.usernames.indexOf(user.username) === -1) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorHistory' }));
	}

	if (room && room.v && room.v._id) {
		return TAGT.models.Rooms.findByVisitorId(room.v._id);
	} else {
		return this.ready();
	}
});
