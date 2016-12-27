Meteor.publish('livechat:queue', function() {
	if (!this.userId) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:queue' }));
	}

	if (!TAGT.authz.hasPermission(this.userId, 'view-l-room')) {
		return this.error(new Meteor.Error('error-not-authorized', 'Not authorized', { publish: 'livechat:queue' }));
	}

	// let sort = { count: 1, sort: 1, username: 1 };
	// let onlineUsers = {};

	// let handleUsers = TAGT.models.Users.findOnlineAgents().observeChanges({
	// 	added(id, fields) {
	// 		onlineUsers[fields.username] = 1;
	// 		// this.added('livechatQueueUser', id, fields);
	// 	},
	// 	changed(id, fields) {
	// 		onlineUsers[fields.username] = 1;
	// 		// this.changed('livechatQueueUser', id, fields);
	// 	},
	// 	removed(id) {
	// 		this.removed('livechatQueueUser', id);
	// 	}
	// });

	let self = this;

	let handleDepts = TAGT.models.LivechatDepartmentAgents.findUsersInQueue().observeChanges({
		added(id, fields) {
			self.added('livechatQueueUser', id, fields);
		},
		changed(id, fields) {
			self.changed('livechatQueueUser', id, fields);
		},
		removed(id) {
			self.removed('livechatQueueUser', id);
		}
	});

	this.ready();

	this.onStop(() => {
		// handleUsers.stop();
		handleDepts.stop();
	});
});
