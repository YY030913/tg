Meteor.methods
	setUserActiveStatus: (userId, active) ->

		check userId, String
		check active, Boolean

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'setUserActiveStatus' }

		unless TAGT.authz.hasPermission( Meteor.userId(), 'edit-other-user-active-status') is true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'setUserActiveStatus' }

		user = TAGT.models.Users.findOneById userId

		TAGT.models.Users.setUserActive userId, active
		TAGT.models.Subscriptions.setArchivedByUsername user?.username, !active

		if active is false
			TAGT.models.Users.unsetLoginTokens userId

		return true
