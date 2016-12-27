Meteor.methods
	joinTag: (_id) ->
		user = Meteor.user()
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'joinTag' }

		if TAGT.authz.hasPermission(Meteor.userId(), 'join-tag') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'joinTag' }

		

		tag = TAGT.models.Tags.findOne {_id: _id}
		
		tagSubscription = TAGT.models.DebateSubscriptions.findOne {name: tag.name}


		if tag? and tagSubscription?
			TAGT.models.Tags.pushMember tag._id, {_id: user._id, username: user.username}
			TAGT.models.DebateSubscriptions.createWithTagAndUser tag, {_id: user._id, username: user.username}

		return true