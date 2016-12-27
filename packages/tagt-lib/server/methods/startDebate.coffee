Meteor.methods
	startDebate: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'startDebate' }

		if TAGT.authz.hasPermission(user._id, 'update-debate-favorite') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'startDebate' }

		now = new Date()

		option = {
			name: 1
		}

		u = {
			_id: user._id,
			name: user.username
		}

		debate = TAGT.models.Debates.findOne {_id: _id}
		
		if debate?
			TAGT.models.Debates.pushFavoriteById _id, u
		return true