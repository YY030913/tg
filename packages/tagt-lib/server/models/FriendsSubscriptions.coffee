TAGT.models.FriendsSubscriptions = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'friend_subscription'

		@tryEnsureIndex { 'u._id': 1 }, { unique: 1 }
		@tryEnsureIndex { 'alert': 1, 'u._id': 1 }
		@tryEnsureIndex { 'roles': 1 }
		@tryEnsureIndex { 'u._id': 1, 'name': 1, 't': 1 }
		@tryEnsureIndex { 'u._id': 1, 'name': 1, 't': 1, 'code': 1 }, { unique: 1 }
		@tryEnsureIndex { 'open': 1 }
		@tryEnsureIndex { 'alert': 1 }
		@tryEnsureIndex { 'unread': 1 }
		@tryEnsureIndex { 'ts': 1 }
		@tryEnsureIndex { 'ls': 1 }
		@tryEnsureIndex { 'desktopNotifications': 1 }, { sparse: 1 }
		@tryEnsureIndex { 'mobilePushNotifications': 1 }, { sparse: 1 }
		@tryEnsureIndex { 'emailNotifications': 1 }, { sparse: 1 }


	# FIND ONE
	findOneByUserId: (userId) ->
		query =
			"u._id": userId

		return @findOne query

	# FIND
	findByUserId: (userId, options) ->
		query =
			"u._id": userId

		return @find query, options

	# FIND
	findByRoles: (roles, options) ->
		roles = [].concat roles
		query =
			"roles": { $in: roles }

		return @find query, options


	getLastSeen: (options = {}) ->
		query = { ls: { $exists: 1 } }
		options.sort = { ls: -1 }
		options.limit = 1

		return @find(query, options)?.fetch?()?[0]?.ls

	# UPDATE
	archiveByUserId: (userId) ->
		query =
			'u._id': userId

		update =
			$set:
				alert: false
				open: false
				archived: true

		return @update query, update

	unarchiveByUserId: (userId) ->
		query =
			'u._id': userId

		update =
			$set:
				alert: false
				open: true
				archived: false

		return @update query, update

	hideByUserId: (userId) ->
		query =
			'u._id': userId

		update =
			$set:
				alert: false
				open: false

		return @update query, update

	openByUserId: (userId) ->
		query =
			'u._id': userId

		update =
			$set:
				open: true

		return @update query, update

	setAsReadByUserId: (userId) ->
		query =
			'u._id': userId

		update =
			$set:
				open: true
				alert: false
				unread: 0
				ls: new Date

		return @update query, update


	updateNameAndAlertByRoomId: (name) ->
		query =

		update =
			$set:
				name: name
				alert: true

		return @update query, update, { multi: true }


	setUserUsernameByUserId: (userId, username) ->
		query =
			"u._id": userId

		update =
			$set:
				"u.username": username

		return @update query, update, { multi: true }


	incUnreadForUserIds: (userIds, inc=1) ->
		query =
			'u._id':
				$in: userIds

		update =
			$set:
				alert: true
				open: true
			$inc:
				unread: inc

		return @update query, update, { multi: true }


	addRoleById: (_id, role) ->
		query =
			_id: _id

		update =
			$addToSet:
				roles: role

		return @update query, update

	removeRoleById: (_id, role) ->
		query =
			_id: _id

		update =
			$pull:
				roles: role

		return @update query, update

	# INSERT
	createWithUser: (user, extraData) ->
		subscription =
			open: false
			alert: false
			unread: 0
			ts: new Date
			u:
				_id: user._id
				username: user.username

		_.extend subscription, extraData

		return @insert subscription


	# REMOVE
	removeByUserId: (userId) ->
		query =
			"u._id": userId

		return @remove query
