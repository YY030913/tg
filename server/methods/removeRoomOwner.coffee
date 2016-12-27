Meteor.methods
	removeRoomOwner: (rid, userId) ->

		check rid, String
		check userId, String

		unless Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'removeRoomOwner' }

		unless TAGT.authz.hasPermission Meteor.userId(), 'set-owner', rid
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'removeRoomOwner' }

		subscription = TAGT.models.Subscriptions.findOneByRoomIdAndUserId rid, userId
		unless subscription?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'removeRoomOwner' }

		numOwners = TAGT.authz.getUsersInRole('owner', rid).count()
		if numOwners is 1
			throw new Meteor.Error 'error-remove-last-owner', 'This is the last owner. Please set a new owner before removing this one.', { method: 'removeRoomOwner' }

		TAGT.models.Subscriptions.removeRoleById(subscription._id, 'owner')

		user = TAGT.models.Users.findOneById userId
		fromUser = TAGT.models.Users.findOneById Meteor.userId()
		TAGT.models.Messages.createSubscriptionRoleRemovedWithRoomIdAndUser rid, user,
			u:
				_id: fromUser._id
				username: fromUser.username
			role: 'owner'

		if TAGT.settings.get('UI_DisplayRoles')
			TAGT.Notifications.notifyAll('roles-change', { type: 'removed', _id: 'owner', u: { _id: user._id, username: user.username }, scope: rid });

		return true
