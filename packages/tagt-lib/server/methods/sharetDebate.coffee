Meteor.methods
	sharetDebate: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'updateDebateFlag' }

		if TAGT.authz.hasPermission(user._id, 'update-debate-tag') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'updateDebateFlag' }

		now = new Date()

		option = {
			name: 1
		}

		u = {
			_id: user._id
			name: user.username
		}


		debate = TAGT.models.Debates.findOne {_id: _id}
		
		if debate?
			TAGT.models.Debates.pushShareById _id, u
		return true