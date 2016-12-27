TAGT.QueueMethods = {
	/* Least Amount Queuing method:
	 *
	 * default method where the agent with the least number
	 * of open chats is paired with the incoming livechat
	 */
	'Least_Amount' : function(guest, message, roomInfo) {
		const agent = TAGT.Livechat.getNextAgent(guest.department);
		if (!agent) {
			throw new Meteor.Error('no-agent-online', 'Sorry, no online agents');
		}

		const roomCode = TAGT.models.Rooms.getNextLivechatRoomCode();

		const room = _.extend({
			_id: message.rid,
			msgs: 1,
			lm: new Date(),
			code: roomCode,
			label: guest.name || guest.username,
			usernames: [agent.username, guest.username],
			t: 'l',
			ts: new Date(),
			v: {
				_id: guest._id,
				token: message.token
			},
			servedBy: {
				_id: agent.agentId,
				username: agent.username
			},
			cl: false,
			open: true,
			waitingResponse: true
		}, roomInfo);
		let subscriptionData = {
			rid: message.rid,
			name: guest.name || guest.username,
			alert: true,
			open: true,
			unread: 1,
			code: roomCode,
			u: {
				_id: agent.agentId,
				username: agent.username
			},
			t: 'l',
			desktopNotifications: 'all',
			mobilePushNotifications: 'all',
			emailNotifications: 'all'
		};

		TAGT.models.Rooms.insert(room);
		TAGT.models.Subscriptions.insert(subscriptionData);

		return room;
	},
	/* Guest Pool Queuing Method:
	 *
	 * An incomming livechat is created as an Inquiry
	 * which is picked up from an agent.
	 * An Inquiry is visible to all agents (TODO: in the correct department)
     *
	 * A room is still created with the initial message, but it is occupied by
	 * only the client until paired with an agent
	 */
	'Guest_Pool' : function(guest, message, roomInfo) {
		let agents = TAGT.Livechat.getOnlineAgents(guest.department);

		if (agents.count() === 0 && TAGT.settings.get('Livechat_guest_pool_with_no_agents')) {
			agents = TAGT.Livechat.getAgents(guest.department);
		}

		if (agents.count() === 0) {
			throw new Meteor.Error('no-agent-online', 'Sorry, no online agents');
		}

		const roomCode = TAGT.models.Rooms.getNextLivechatRoomCode();

		const agentIds = [];

		agents.forEach((agent) => {
			if (guest.department) {
				agentIds.push(agent.agentId);
			} else {
				agentIds.push(agent._id);
			}
		});

		var inquiry = {
			rid: message.rid,
			message: message.msg,
			name: guest.name || guest.username,
			ts: new Date(),
			code: roomCode,
			department: guest.department,
			agents: agentIds,
			status: 'open',
			t: 'l'
		};
		const room = _.extend({
			_id: message.rid,
			msgs: 1,
			lm: new Date(),
			code: roomCode,
			label: guest.name || guest.username,
			usernames: [guest.username],
			t: 'l',
			ts: new Date(),
			v: {
				_id: guest._id,
				token: message.token
			},
			cl: false,
			open: true,
			waitingResponse: true
		}, roomInfo);
		TAGT.models.LivechatInquiry.insert(inquiry);
		TAGT.models.Rooms.insert(room);

		return room;
	}
};
