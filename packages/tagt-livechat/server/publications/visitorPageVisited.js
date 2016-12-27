Meteor.publish('livechat:visitorPageVisited', function({ rid: roomId }) {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorPageVisited' }));
	}

	if (!TAGT.authz.hasPermission(this.userId, 'view-l-room')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:visitorPageVisited' }));
	}

	var room = TAGT.models.Rooms.findOneById(roomId);

	if (room && room.v && room.v.token) {
		return TAGT.models.LivechatPageVisited.findByToken(room.v.token);
	} else {
		return this.ready();
	}
});
