Meteor.methods
	addRoomModerator: (rid, userId) ->

		check rid, String
		check userId, String

		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'addRoomModerator' }

		unless TAGT.authz.hasPermission Meteor.userId(), 'set-moderator', rid
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'addRoomModerator' }

		subscription = TAGT.models.Subscriptions.findOneByRoomIdAndUserId rid, userId
		unless subscription?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'addRoomModerator' }

		TAGT.models.Subscriptions.addRoleById(subscription._id, 'moderator')

		user = TAGT.models.Users.findOneById userId
		fromUser = TAGT.models.Users.findOneById Meteor.userId()
		TAGT.models.Messages.createSubscriptionRoleAddedWithRoomIdAndUser rid, user,
			u:
				_id: fromUser._id
				username: fromUser.username
			role: 'moderator'

		if TAGT.settings.get('UI_DisplayRoles')
			TAGT.Notifications.notifyAll('roles-change', { type: 'added', _id: 'moderator', u: { _id: user._id, username: user.username }, scope: rid });

		return true
