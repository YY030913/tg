Meteor.startup ->
	TAGT.roomTypes.setPublish 'c', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				muted: 1
				archived: 1
				ro: 1
				jitsiTimeout: 1
				description: 1
				sysMes: 1
				joinCodeRequired: 1
				
				left: 1
				right: 1
				connected: 1
				archived: 1
				invite: 1
				did: 1


		if TAGT.authz.hasPermission(this.userId, 'view-join-code')
			options.fields.joinCode = 1

		if TAGT.authz.hasPermission(this.userId, 'view-c-room')
			return TAGT.models.Rooms.findByTypeAndName 'c', identifier, options
		else if TAGT.authz.hasPermission(this.userId, 'view-joined-room')
			roomId = TAGT.models.Subscriptions.findByTypeNameAndUserId('c', identifier, this.userId).fetch()
			if roomId.length > 0
				return TAGT.models.Rooms.findById(roomId[0]?.rid, options)

		return this.ready()

	TAGT.roomTypes.setPublish 'p', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				muted: 1
				archived: 1
				ro: 1
				jitsiTimeout: 1
				description: 1
				sysMes: 1

				left: 1
				right: 1
				connected: 1
				invite: 1

		user = TAGT.models.Users.findOneById this.userId, fields: username: 1
		return TAGT.models.Rooms.findByTypeAndNameContainingUsername 'p', identifier, user.username, options

	TAGT.roomTypes.setPublish 'd', (identifier) ->
		options =
			fields:
				name: 1
				t: 1
				cl: 1
				u: 1
				usernames: 1
				topic: 1
				jitsiTimeout: 1

				left: 1
				right: 1
				connected: 1
				invite: 1

		user = TAGT.models.Users.findOneById this.userId, fields: username: 1
		if TAGT.authz.hasAtLeastOnePermission(this.userId, ['view-d-room', 'view-joined-room'])
			return TAGT.models.Rooms.findByTypeContainigUsernames 'd', [user.username, identifier], options
		return this.ready()
