TAGT.API.v1.addRoute 'info', authRequired: false,
	get: -> TAGT.Info


TAGT.API.v1.addRoute 'me', authRequired: true,
	get: ->
		return _.pick @user, [
			'_id'
			'name'
			'emails'
			'status'
			'statusConnection'
			'username'
			'utcOffset'
			'active'
			'language'
		]


# Send Channel Message
TAGT.API.v1.addRoute 'chat.messageExamples', authRequired: true,
	get: ->
		return TAGT.API.v1.success
			body: [
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'talk get'
				text: 'Sample text 1'
				trigger_word: 'Sample'
			,
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'talk get'
				text: 'Sample text 2'
				trigger_word: 'Sample'
			,
				token: Random.id(24)
				channel_id: Random.id()
				channel_name: 'general'
				timestamp: new Date
				user_id: Random.id()
				user_name: 'talk get'
				text: 'Sample text 3'
				trigger_word: 'Sample'
			]


# Send Channel Message
TAGT.API.v1.addRoute 'chat.postMessage', authRequired: true,
	post: ->
		try
			messageReturn = processWebhookMessage @bodyParams, @user

			if not messageReturn?
				return TAGT.API.v1.failure 'unknown-error'

			return TAGT.API.v1.success
				ts: Date.now()
				channel: messageReturn.channel
				message: messageReturn.message
		catch e
			return TAGT.API.v1.failure e.error

# Set Channel Topic
TAGT.API.v1.addRoute 'channels.setTopic', authRequired: true,
	post: ->
		if not @bodyParams.channel?
			return TAGT.API.v1.failure 'Body param "channel" is required'

		if not @bodyParams.topic?
			return TAGT.API.v1.failure 'Body param "topic" is required'

		unless TAGT.authz.hasPermission(@userId, 'edit-room', @bodyParams.channel)
			return TAGT.API.v1.unauthorized()

		if not TAGT.saveRoomTopic(@bodyParams.channel, @bodyParams.topic, @user)
			return TAGT.API.v1.failure 'invalid_channel'

		return TAGT.API.v1.success
			topic: @bodyParams.topic


# Create Channel
TAGT.API.v1.addRoute 'channels.create', authRequired: true,
	post: ->
		if not @bodyParams.name?
			return TAGT.API.v1.failure 'Body param "name" is required'

		if not TAGT.authz.hasPermission(@userId, 'create-c')
			return TAGT.API.v1.unauthorized()

		id = undefined
		try
			Meteor.runAsUser this.userId, =>
				id = Meteor.call 'createChannel', @bodyParams.name, []
		catch e
			return TAGT.API.v1.failure e.name + ': ' + e.message

		return TAGT.API.v1.success
			channel: TAGT.models.Rooms.findOne({_id: id.rid})

# List Private Groups a user has access to
TAGT.API.v1.addRoute 'groups.list', authRequired: true,
	get: ->
		roomIds = _.pluck TAGT.models.Subscriptions.findByTypeAndUserId('p', @userId).fetch(), 'rid'
		return { groups: TAGT.models.Rooms.findByIds(roomIds).fetch() }

# Add All Users to Channel
TAGT.API.v1.addRoute 'channel.addall', authRequired: true,
	post: ->

		id = undefined
		try
			Meteor.runAsUser this.userId, =>
				id = Meteor.call 'addAllUserToRoom', @bodyParams.roomId, []
		catch e
			return TAGT.API.v1.failure e.name + ': ' + e.message

		return TAGT.API.v1.success
			channel: TAGT.models.Rooms.findOne({_id: @bodyParams.roomId})

# List all users
TAGT.API.v1.addRoute 'users.list', authRequired: true,
	get: ->
		if TAGT.authz.hasRole(@userId, 'admin') is false
			return TAGT.API.v1.unauthorized()

		return { users: TAGT.models.Users.find().fetch() }

# Create user
TAGT.API.v1.addRoute 'users.create', authRequired: true,
	post: ->
		try
			check @bodyParams,
				email: String
				name: String
				password: String
				username: String
				role: Match.Maybe(String)
				joinDefaultChannels: Match.Maybe(Boolean)
				requirePasswordChange: Match.Maybe(Boolean)
				sendWelcomeEmail: Match.Maybe(Boolean)
				verified: Match.Maybe(Boolean)
				customFields: Match.Maybe(Object)

			# check username availability first (to not create an user without a username)
			try
				nameValidation = new RegExp '^' + TAGT.settings.get('UTF8_Names_Validation') + '$'
			catch
				nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

			if not nameValidation.test @bodyParams.username
				return TAGT.API.v1.failure 'Invalid username'

			unless TAGT.checkUsernameAvailability @bodyParams.username
				return TAGT.API.v1.failure 'Username not available'

			userData = {}

			newUserId = TAGT.saveUser(@userId, @bodyParams)

			if @bodyParams.customFields?
				TAGT.saveCustomFields(newUserId, @bodyParams.customFields)

			return TAGT.API.v1.success
				user: TAGT.models.Users.findOneById(newUserId)
		catch e
			return TAGT.API.v1.failure e.name + ': ' + e.message

# Update user
TAGT.API.v1.addRoute 'user.update', authRequired: true,
	post: ->
		try
			check @bodyParams,
				userId: String
				data:
					email: Match.Maybe(String)
					name: Match.Maybe(String)
					password: Match.Maybe(String)
					username: Match.Maybe(String)
					role: Match.Maybe(String)
					joinDefaultChannels: Match.Maybe(Boolean)
					requirePasswordChange: Match.Maybe(Boolean)
					sendWelcomeEmail: Match.Maybe(Boolean)
					verified: Match.Maybe(Boolean)
					customFields: Match.Maybe(Object)

			userData = _.extend({ _id: @bodyParams.userId }, @bodyParams.data)

			TAGT.saveUser(@userId, userData)

			if @bodyParams.data.customFields?
				TAGT.saveCustomFields(@bodyParams.userId, @bodyParams.data.customFields)

			return TAGT.API.v1.success
				user: TAGT.models.Users.findOneById(@bodyParams.userId)
		catch e
			return TAGT.API.v1.failure e.name + ': ' + e.message

# Get User Information
TAGT.API.v1.addRoute 'user.info', authRequired: true,
	post: ->
		if TAGT.authz.hasRole(@userId, 'admin') is false
			return TAGT.API.v1.unauthorized()

		return { user: TAGT.models.Users.findOneByUsername @bodyParams.name }

# Get User Presence
TAGT.API.v1.addRoute 'user.getpresence', authRequired: true,
	post: ->
		return { user: TAGT.models.Users.findOne( { username: @bodyParams.name} , {fields: {status: 1}} ) }

# Delete User
TAGT.API.v1.addRoute 'users.delete', authRequired: true,
	post: ->
		if not @bodyParams.userId?
			return TAGT.API.v1.failure 'Body param "userId" is required'

		if not TAGT.authz.hasPermission(@userId, 'delete-user')
			return TAGT.API.v1.unauthorized()

		id = undefined
		try
			Meteor.runAsUser this.userId, =>
				id = Meteor.call 'deleteUser', @bodyParams.userId, []
		catch e
			return TAGT.API.v1.failure e.name + ': ' + e.message

		return TAGT.API.v1.success

# Create Private Group
TAGT.API.v1.addRoute 'groups.create', authRequired: true,
	post: ->
		if not @bodyParams.name?
			return TAGT.API.v1.failure 'Body param "name" is required'

		if not TAGT.authz.hasPermission(@userId, 'create-p')
			return TAGT.API.v1.unauthorized()

		id = undefined
		try
			if not @bodyParams.members?
				Meteor.runAsUser this.userId, =>
					id = Meteor.call 'createPrivateGroup', @bodyParams.name, []
			else
			  Meteor.runAsUser this.userId, =>
				  id = Meteor.call 'createPrivateGroup', @bodyParams.name, @bodyParams.members, []
		catch e
			return TAGT.API.v1.failure e.name + ': ' + e.message

		return TAGT.API.v1.success
			group: TAGT.models.Rooms.findOne({_id: id.rid})

