TAGT.models.DebateSubscriptions = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'debate_subscription'

		@tryEnsureIndex { 'tid': 1, 'u._id': 1 }, { unique: 1 }
		@tryEnsureIndex { 'tid': 1, 'alert': 1, 'u._id': 1 }
		@tryEnsureIndex { 'tid': 1, 'roles': 1 }
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
	findOneByTagIdAndUserId: (tagId, userId) ->
		query =
			tid: tagId
			"u._id": userId
			del: {
				$ne: true
			}

		return @findOne query

	###
	findOneByMemeberAndTag: (user, tag) ->
		query =
			tid: tag._id
			"members._id": user._id
			del: {
				$ne: true
			}
		return @findOne query
	###

	# FIND
	findByUserId: (userId, options) ->
		query =
			"u._id": userId
			del: {
				$ne: true
			}
		return @find query, options
	###
	findByMembersId: (userId, options) ->
		query =
			"members._id": userId
			del: {
				$ne: true
			}
		return @find query, options
	###

	# FIND
	findByTagIdAndRoles: (tagId, roles, options) ->
		roles = [].concat roles
		query =
			"tid": tagId
			"roles": { $in: roles }
			del: {
				$ne: true
			}
		return @find query, options

	findByType: (types, options) ->
		query =
			t:
				$in: types
			del: {
				$ne: true
			}
		return @find query, options

	findByTypeAndUserId: (type, userId, options) ->
		query =
			t: type
			'u._id': userId
			del: {
				$ne: true
			}
		return @find query, options

	findByTypeNameAndUserId: (type, name, userId, options) ->
		query =
			t: type
			name: name
			'u._id': userId
			del: {
				$ne: true
			}
		return @find query, options

	getLastSeen: (options = {}) ->
		query = { 
			ls: { $exists: 1 } 
			del: {
				$ne: true
			}
		}
		options.sort = { ls: -1 }
		options.limit = 1

		return @find(query, options)?.fetch?()?[0]?.ls

	# UPDATE
	updateAllUsernamesByUserId: (userId, username) ->
		query =
			"u._id": userId

		update =
			$set:
				"u.username": username

		return @update query, update, { multi: true }
	
	archiveByTagIdAndUserId: (tagId, userId) ->
		query =
			tid: tagId
			'u._id': userId
			del: {
				$ne: true
			}

		update =
			$set:
				alert: false
				open: false
				archived: true

		return @update query, update

	unarchiveByTagIdAndUserId: (tagId, userId) ->
		query =
			tid: tagId
			'u._id': userId
			del: {
				$ne: true
			}

		update =
			$set:
				alert: false
				open: true
				archived: false

		return @update query, update

	hideByTagIdAndUserId: (tagId, userId) ->
		query =
			tid: tagId
			'u._id': userId
			del: {
				$ne: true
			}

		update =
			$set:
				alert: false
				open: false

		return @update query, update

	openByTagIdAndUserId: (tagId, userId) ->
		query =
			tid: tagId
			'u._id': userId
			del: {
				$ne: true
			}

		update =
			$set:
				open: true

		return @update query, update

	setAsReadByTagIdAndUserId: (tagId, userId) ->
		query =
			tid: tagId
			'u._id': userId
			del: {
				$ne: true
			}

		update =
			$set:
				open: true
				alert: false
				unread: 0
				ls: new Date

		return @update query, update


	setFavoriteByTagIdAndUserId: (tagId, userId, favorite=true) ->
		query =
			tid: tagId
			'u._id': userId
			del: {
				$ne: true
			}

		update =
			$set:
				f: favorite

		return @update query, update

	updateNameAndAlertByTagId: (tagId, name) ->
		query =
			tid: tagId
			del: {
				$ne: true
			}

		update =
			$set:
				name: name
				alert: true

		return @update query, update, { multi: true }

	updateNameByTagId: (tagId, name) ->
		query =
			tid: tagId
			del: {
				$ne: true
			}

		update =
			$set:
				name: name

		return @update query, update, { multi: true }

	setUserUsernameByUserId: (userId, username) ->
		query =
			"u._id": userId
			del: {
				$ne: true
			}

		update =
			$set:
				"u.username": username

		return @update query, update, { multi: true }

	setNameForDirectRoomsWithOldName: (oldName, name) ->
		query =
			name: oldName
			t: "d"
			del: {
				$ne: true
			}
		update =
			$set:
				name: name

		return @update query, update, { multi: true }

	incUnreadOfDirectForTagIdExcludingUserId: (tagId, userId, inc=1) ->
		query =
			tid: tagId
			t: 'd'
			'u._id':
				$ne: userId
			del: {
				$ne: true
			}

		update =
			$set:
				alert: true
				open: true
			$inc:
				unread: inc

		return @update query, update, { multi: true }

	incUnreadForTagIdExcludingUserId: (tagId, userId, inc=1) ->
		query =
			tid: tagId
			'u._id':
				$ne: userId
			del: {
				$ne: true
			}

		update =
			$set:
				alert: true
				open: true
			$inc:
				unread: inc

		return @update query, update, { multi: true }

	incUnreadForTagIdAndUserIds: (tagId, userIds, inc=1) ->
		query =
			tid: tagId
			'u._id':
				$in: userIds
			del: {
				$ne: true
			}

		update =
			$set:
				alert: true
				open: true
			$inc:
				unread: inc

		return @update query, update, { multi: true }

	setAlertForTagIdExcludingUserId: (tagId, userId, alert=true) ->
		query =
			tid: tagId
			alert:
				$ne: alert
			'u._id':
				$ne: userId
			del: {
				$ne: true
			}

		update =
			$set:
				alert: alert
				open: true

		return @update query, update, { multi: true }

	updateTypeByTagId: (tagId, type) ->
		query =
			tid: tagId
			del: {
				$ne: true
			}

		update =
			$set:
				t: type

		return @update query, update, { multi: true }

	addRoleById: (_id, role) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$addToSet:
				roles: role

		return @update query, update

	removeRoleById: (_id, role) ->
		query =
			_id: _id
			del: {
				$ne: true
			}
		update =
			$pull:
				roles: role

		return @update query, update

	# PUSH
	###
	pushMember: (_id, member) ->
		member.ts = new Date()
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				members: member

		return @update query, update
	###

	# PULL
	pullMember: (_id, member) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$pull: 
				members: member

		return @update query, update

	# INSERT
	createWithTagAndUser: (tag, user, extraData) ->
		subscription =
			open: false
			alert: false
			del: false
			unread: 0
			ts: tag.ts
			tid: tag._id
			name: tag.name
			t: tag.t
			u:
				_id: user._id
				username: user.username
			# members: []

		_.extend subscription, extraData
		return @insert subscription


	# REMOVE
	removeByUserId: (userId) ->
		query =
			"u._id": userId

		return @remove query

	removeByTagId: (tagId) ->
		query =
			tid: tagId

		return @remove query

	removeByTagIdAndUserId: (tagId, userId) ->
		query =
			tid: tagId
			"u._id": userId

		return @remove query
