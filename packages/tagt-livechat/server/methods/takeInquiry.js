Meteor.methods({
	'livechat:takeInquiry'(inquiryId) {
		if (!Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'view-l-room')) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'livechat:takeInquiry' });
		}

		const inquiry = TAGT.models.LivechatInquiry.findOneById(inquiryId);

		if (!inquiry || inquiry.status === 'taken') {
			throw new Meteor.Error('error-not-allowed', 'Inquiry already taken', { method: 'livechat:takeInquiry' });
		}

		const user = TAGT.models.Users.findOneById(Meteor.userId());

		const agent = {
			agentId: user._id,
			username: user.username
		};

		// add subscription
		var subscriptionData = {
			rid: inquiry.rid,
			name: inquiry.name,
			alert: true,
			open: true,
			unread: 1,
			code: inquiry.code,
			u: {
				_id: agent.agentId,
				username: agent.username
			},
			t: 'l',
			desktopNotifications: 'all',
			mobilePushNotifications: 'all',
			emailNotifications: 'all'
		};
		TAGT.models.Subscriptions.insert(subscriptionData);

		const room = TAGT.models.Rooms.findOneById(inquiry.rid);
		const usernames = room.usernames.concat(agent.username);

		TAGT.models.Rooms.changeAgentByRoomId(inquiry.rid, usernames, agent);

		// mark inquiry as taken
		TAGT.models.LivechatInquiry.takeInquiry(inquiry._id);

		// return room corresponding to inquiry (for redirecting agent to the room route)
		return TAGT.models.Rooms.findOneById(inquiry.rid);
	}
});
