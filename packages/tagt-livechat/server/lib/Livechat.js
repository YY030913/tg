/* globals HTTP */
import UAParser from 'ua-parser-js';

TAGT.Livechat = {
	historyMonitorType: 'url',

	logger: new Logger('Livechat', {
		sections: {
			webhook: 'Webhook'
		}
	}),

	getNextAgent(department) {
		if (department) {
			return TAGT.models.LivechatDepartmentAgents.getNextAgentForDepartment(department);
		} else {
			return TAGT.models.Users.getNextAgent();
		}
	},
	getAgents(department) {
		if (department) {
			return TAGT.models.LivechatDepartmentAgents.findByDepartmentId(department);
		} else {
			return TAGT.models.Users.findAgents();
		}
	},
	getOnlineAgents(department) {
		if (department) {
			return TAGT.models.LivechatDepartmentAgents.getOnlineForDepartment(department);
		} else {
			return TAGT.models.Users.findOnlineAgents();
		}
	},
	sendMessage({ guest, message, roomInfo }) {
		var room = TAGT.models.Rooms.findOneById(message.rid);
		var newRoom = false;

		if (room && !room.open) {
			message.rid = Random.id();
			room = null;
		}

		if (room == null) {
			// if no department selected verify if there is at least one active and choose one randomly
			if (!guest.department) {
				var departments = TAGT.models.LivechatDepartment.findEnabledWithAgents();
				if (departments.count() > 0) {
					guest.department = departments.fetch()[0]._id;
				}
			}

			// delegate room creation to QueueMethods
			const routingMethod = TAGT.settings.get('Livechat_Routing_Method');
			room = TAGT.QueueMethods[routingMethod](guest, message, roomInfo);

			newRoom = true;
		} else {
			room = Meteor.call('canAccessRoom', message.rid, guest._id);
		}
		if (!room) {
			throw new Meteor.Error('cannot-acess-room');
		}
		if (guest.name) {
			message.alias = guest.name;
		}
		return _.extend(TAGT.sendMessage(guest, message, room), { newRoom: newRoom });
	},
	registerGuest({ token, name, email, department, phone, loginToken, username } = {}) {
		check(token, String);

		const user = TAGT.models.Users.getVisitorByToken(token, { fields: { _id: 1 } });

		if (user) {
			throw new Meteor.Error('token-already-exists', 'Token already exists');
		}

		if (!username) {
			username = TAGT.models.Users.getNextVisitorUsername();
		}

		let updateUser = {
			$set: {
				profile: {
					guest: true,
					token: token
				}
			}
		};

		var existingUser = null;

		var userId;

		if (s.trim(email) !== '' && (existingUser = TAGT.models.Users.findOneByEmailAddress(email))) {
			if (existingUser.type !== 'visitor') {
				throw new Meteor.Error('error-invalid-user', 'This email belongs to a registered user.');
			}

			updateUser.$addToSet = {
				globalRoles: 'livechat-guest'
			};

			if (loginToken) {
				updateUser.$addToSet['services.resume.loginTokens'] = loginToken;
			}

			userId = existingUser._id;
		} else {
			updateUser.$set.name = name;

			var userData = {
				username: username,
				globalRoles: ['livechat-guest'],
				department: department,
				type: 'visitor'
			};

			if (this.connection) {
				userData.userAgent = this.connection.httpHeaders['user-agent'];
				userData.ip = this.connection.httpHeaders['x-real-ip'] || this.connection.clientAddress;
				userData.host = this.connection.httpHeaders.host;
			}

			userId = Accounts.insertUserDoc({}, userData);

			if (loginToken) {
				updateUser.$set.services = {
					resume: {
						loginTokens: [ loginToken ]
					}
				};
			}
		}

		if (phone) {
			updateUser.$set.phone = [
				{ phoneNumber: phone.number }
			];
		}

		if (email && email.trim() !== '') {
			updateUser.$set.emails = [
				{ address: email }
			];
		}

		Meteor.users.update(userId, updateUser);

		return userId;
	},

	saveGuest({ _id, name, email, phone }) {
		let updateData = {};

		if (name) {
			updateData.name = name;
		}
		if (email) {
			updateData.email = email;
		}
		if (phone) {
			updateData.phone = phone;
		}
		const ret = TAGT.models.Users.saveUserById(_id, updateData);

		Meteor.defer(() => {
			TAGT.callbacks.run('livechat.saveGuest', updateData);
		});

		return ret;
	},

	closeRoom({ user, room, comment }) {
		let now = new Date();
		TAGT.models.Rooms.closeByRoomId(room._id, {
			user: {
				_id: user._id,
				username: user.username
			},
			closedAt: now,
			chatDuration: (now.getTime() - room.ts) / 1000
		});

		const message = {
			t: 'livechat-close',
			msg: comment,
			groupable: false
		};

		TAGT.sendMessage(user, message, room);

		TAGT.models.Subscriptions.hideByRoomIdAndUserId(room._id, user._id);

		Meteor.defer(() => {
			TAGT.callbacks.run('livechat.closeRoom', room);
		});

		return true;
	},

	getInitSettings() {
		let settings = {};

		TAGT.models.Settings.findNotHiddenPublic([
			'Livechat_title',
			'Livechat_title_color',
			'Livechat_enabled',
			'Livechat_registration_form',
			'Livechat_offline_title',
			'Livechat_offline_title_color',
			'Livechat_offline_message',
			'Livechat_offline_success_message',
			'Livechat_offline_form_unavailable',
			'Livechat_display_offline_form',
			'Language'
		]).forEach((setting) => {
			settings[setting._id] = setting.value;
		});

		return settings;
	},

	saveRoomInfo(roomData, guestData) {
		if (!TAGT.models.Rooms.saveRoomById(roomData._id, roomData)) {
			return false;
		}

		Meteor.defer(() => {
			TAGT.callbacks.run('livechat.saveRoom', roomData);
		});

		if (!_.isEmpty(guestData.name)) {
			return TAGT.models.Rooms.setLabelByRoomId(roomData._id, guestData.name) && TAGT.models.Subscriptions.updateNameByRoomId(roomData._id, guestData.name);
		}
	},

	forwardOpenChats(userId) {
		TAGT.models.Rooms.findOpenByAgent(userId).forEach((room) => {
			const guest = TAGT.models.Users.findOneById(room.v._id);
			this.transfer(room, guest, { departmentId: guest.department });
		});
	},

	savePageHistory(token, pageInfo) {
		if (pageInfo.change === TAGT.Livechat.historyMonitorType) {
			return TAGT.models.LivechatPageVisited.saveByToken(token, pageInfo);
		}

		return;
	},

	transfer(room, guest, transferData) {
		let agent;

		if (transferData.userId) {
			const user = TAGT.models.Users.findOneById(transferData.userId);
			agent = {
				agentId: user._id,
				username: user.username
			};
		} else {
			agent = TAGT.Livechat.getNextAgent(transferData.departmentId);
		}

		if (agent && agent.agentId !== room.servedBy._id) {
			room.usernames = _.without(room.usernames, room.servedBy.username).concat(agent.username);

			TAGT.models.Rooms.changeAgentByRoomId(room._id, room.usernames, agent);

			let subscriptionData = {
				rid: room._id,
				name: guest.name || guest.username,
				alert: true,
				open: true,
				unread: 1,
				code: room.code,
				u: {
					_id: agent.agentId,
					username: agent.username
				},
				t: 'l',
				desktopNotifications: 'all',
				mobilePushNotifications: 'all',
				emailNotifications: 'all'
			};
			TAGT.models.Subscriptions.removeByRoomIdAndUserId(room._id, room.servedBy._id);

			TAGT.models.Subscriptions.insert(subscriptionData);

			TAGT.models.Messages.createUserLeaveWithRoomIdAndUser(room._id, { _id: room.servedBy._id, username: room.servedBy.username });
			TAGT.models.Messages.createUserJoinWithRoomIdAndUser(room._id, { _id: agent.agentId, username: agent.username });

			return true;
		}

		return false;
	},

	sendRequest(postData, callback, trying = 1) {
		try {
			let options = {
				headers: {
					'X-TAGT-Livechat-Token': TAGT.settings.get('Livechat_secret_token')
				},
				data: postData
			};
			return HTTP.post(TAGT.settings.get('Livechat_webhookUrl'), options);
		} catch (e) {
			TAGT.Livechat.logger.webhook.error('Response error on ' + trying + ' try ->', e);
			// try 10 times after 10 seconds each
			if (trying < 10) {
				TAGT.Livechat.logger.webhook.warn('Will try again in 10 seconds ...');
				trying++;
				setTimeout(Meteor.bindEnvironment(() => {
					TAGT.Livechat.sendRequest(postData, callback, trying);
				}), 10000);
			}
		}
	},

	getLivechatRoomGuestInfo(room) {
		const visitor = TAGT.models.Users.findOneById(room.v._id);
		const agent = TAGT.models.Users.findOneById(room.servedBy._id);

		const ua = new UAParser();
		ua.setUA(visitor.userAgent);

		let postData = {
			_id: room._id,
			label: room.label,
			topic: room.topic,
			code: room.code,
			createdAt: room.ts,
			lastMessageAt: room.lm,
			tags: room.tags,
			customFields: room.livechatData,
			visitor: {
				_id: visitor._id,
				name: visitor.name,
				username: visitor.username,
				email: null,
				phone: null,
				department: visitor.department,
				ip: visitor.ip,
				os: ua.getOS().name && (ua.getOS().name + ' ' + ua.getOS().version),
				browser: ua.getBrowser().name && (ua.getBrowser().name + ' ' + ua.getBrowser().version),
				customFields: visitor.livechatData
			},
			agent: {
				_id: agent._id,
				username: agent.username,
				name: agent.name,
				email: null
			}
		};

		if (room.crmData) {
			postData.crmData = room.crmData;
		}

		if (visitor.emails && visitor.emails.length > 0) {
			postData.visitor.email = visitor.emails[0].address;
		}
		if (visitor.phone && visitor.phone.length > 0) {
			postData.visitor.phone = visitor.phone[0].phoneNumber;
		}

		if (agent.emails && agent.emails.length > 0) {
			postData.agent.email = agent.emails[0].address;
		}

		return postData;
	}
};

TAGT.settings.get('Livechat_history_monitor_type', (key, value) => {
	TAGT.Livechat.historyMonitorType = value;
});
