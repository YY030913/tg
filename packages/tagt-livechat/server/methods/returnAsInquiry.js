Meteor.methods({
	'livechat:returnAsInquiry'(rid) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'view-l-room')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:saveDepartment' });
		}

		// //delete agent and room subscription
		TAGT.models.Subscriptions.removeByRoomId(rid);

		// remove user from room
		var username = Meteor.user().username;

		TAGT.models.Rooms.removeUsernameById(rid, username);

		// find inquiry corresponding to room
		var inquiry = TAGT.models.LivechatInquiry.findOne({rid: rid});

		// mark inquiry as open
		return TAGT.models.LivechatInquiry.openInquiry(inquiry._id);
	}
});
