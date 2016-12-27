Meteor.methods
	unstartDebate: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'unstartDebate' }

		if TAGT.authz.hasPermission(user._id, 'update-debate-favorite') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'unstartDebate' }

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
			TAGT.models.Debates.pullFavoriteById _id, u
		return true