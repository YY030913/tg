Meteor.methods({
	addAllUserToRoom: function(rid) {

		check (rid, String);

		if (TAGT.authz.hasRole(this.userId, 'admin') === true) {
			var now, room, users;
			var userCount = TAGT.models.Users.find().count();
			if (userCount > TAGT.settings.get('API_User_Limit')) {
				throw new Meteor.Error('error-user-limit-exceeded', 'User Limit Exceeded', {
					method: 'addAllToRoom'
				});
			}
			room = TAGT.models.Rooms.findOneById(rid);
			if (room == null) {
				throw new Meteor.Error('error-invalid-room', 'Invalid room', {
					method: 'addAllToRoom'
				});
			}
			users = TAGT.models.Users.find().fetch();
			now = new Date();
			users.forEach(function(user) {
				var subscription;
				subscription = TAGT.models.Subscriptions.findOneByRoomIdAndUserId(rid, user._id);
				if (subscription != null) {
					return;
				}
				TAGT.callbacks.run('beforeJoinRoom', user, room);
				TAGT.models.Rooms.addUsernameById(rid, user.username);
				TAGT.models.Subscriptions.createWithRoomAndUser(room, user, {
					ts: now,
					open: true,
					alert: true,
					unread: 1
				});
				TAGT.models.Messages.createUserJoinWithRoomIdAndUser(rid, user, {
					ts: now
				});
				Meteor.defer(function() {});
				return TAGT.callbacks.run('afterJoinRoom', user, room);
			});
			return true;
		} else {
			throw (new Meteor.Error(403, 'Access to Method Forbidden', {
				method: 'addAllToRoom'
			}));
		}
	}
});
