Meteor.publish('livechat:visitorInfo', function({ rid: roomId }) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorInfo' }));
	}

	if (!TAGT.authz.hasPermission(this.userId, 'view-l-room')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorInfo' }));
	}

	var room = TAGT.models.Rooms.findOneById(roomId);

	if (room && room.v && room.v._id) {
		return TAGT.models.Users.findById(room.v._id);
	} else {
		return this.ready();
	}
});
