Meteor.methods
	updateDebateShare: (_id) ->
		
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'updateDebateShare' }

		if TAGT.authz.hasPermission(Meteor.userId(), 'update-debate-share') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'updateDebateShare' }

		user = Meteor.user()

		debate = TAGT.models.Debates.findOne {_id: _id}
		
		if debate?
			TAGT.models.Debates.pushShareById _id, {userId: user._id, username: user.username}

		return true