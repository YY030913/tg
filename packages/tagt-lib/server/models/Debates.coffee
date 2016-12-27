TAGT.models.Debates = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'debates'

		@tryEnsureIndex { 'name': 1 }, { unique: 1, sparse: 1 }
	#status: 0：关闭永不可见，1：所有人可见，2：私密（通过指定slug访问）

	# FIND ONE
	findOneByName: (name, ext) ->
		query = 
			name: name
			save: true
			del: 
				$ne: true
			_hidden:
				$ne: true

		query = _.extend query, ext
		options = {
		}
		return @findOne query, options

	findOneBySlug: (slug, options) ->

		query =
			_id: slug

		return @findOne query, options

	findOneByQuery: (query, options) ->
		query = _.extend query, {del: {
			$ne: true
		}}
		return @findOne query, options

	# FIND
	findByUser: (uid, options) ->
		query =
			"u._id": uid
			del: {
				$ne: true
			}

		return @find query, options

	findByUserBeforeTime: (uid, timestamp, options) ->
		query =
			"u._id": uid
			ts: {
				$lt: timestamp
			}
			del: {
				$ne: true
			}

		return @find query, options

	findByUserAfterTime: (uid, timestamp, options) ->
		query =
			"u._id": uid
			ts: {
				$gt: timestamp
			}
			del: {
				$ne: true
			}

		return @find query, options

	findList: (query, options) ->

		query = _.extend query, {del: {
			$ne: true
		}}
		return @find query, options

	findVisibleByTagId: (tid, options) ->
		query =
			del: 
				$ne: true
			_hidden:
				$ne: true
			"tags._id": tid

		return @find query, options

	findVisibleInTags: (tids, options) ->
		query =
			del: 
				$ne: true
			_hidden:
				$ne: true
			"tags._id": 
				$in: tids

		return @find query, options

	findVisibleByTagIdBeforeTimestamp: (tid, timestamp, options) ->
		query =
			del: 
				$ne: true
			_hidden:
				$ne: true
			"tags._id": tid
			ts:
				$lt: timestamp

		return @find query, options

	findVisibleByTagIdAfterTimestamp: (tid, timestamp, options) ->
		query =
			del: 
				$ne: true
			_hidden:
				$ne: true
			"tags._id": tid
			ts:
				$gt: timestamp

		return @find query, options

	findVisibleInTagsAfterTimestamp: (tids, timestamp, options) ->
		query =
			del: 
				$ne: true
			_hidden:
				$ne: true
			"tags._id":
				$in: tids
			ts:
				$gt: timestamp

		return @find query, options

	findVisibleInTagsBeforeTimestamp: (tids, timestamp, options) ->
		query =
			del: 
				$ne: true
			_hidden:
				$ne: true
			"tags._id":
				$in: tids
			ts:
				$lt: timestamp

		return @find query, options

	findVisibleByTagIdBetweenTimestamps: (tid, afterTimestamp, beforeTimestamp, options) ->
		query =
			del: 
				$ne: true
			_hidden:
				$ne: true
			"tags._id": tid
			ts:
				$gt: afterTimestamp
				$lt: beforeTimestamp

		return @find query, options

	findVisibleCreatedOrEditedAfterTimestamp: (timestamp, options) ->
		query =
			del: 
				$ne: true
			_hidden: { $ne: true }
			$or: [
				ts:
					$gt: timestamp
			,
				'editedAt':
					$gt: timestamp
			]

		return @find query, options


	# UPDATE
	updateDebateById: (_id, debate) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$set:
				debate: debate
			updateAt:
				new Date()

		return @update query, update

	updateAllUsernamesByUserId: (userId, username) ->
		query =
			"u._id": userId

		update =
			$set:
				"u.username": username

		return @update query, update, { multi: true }

	replaceUsername: (previousUsername, username) ->
		query =
			usernames: previousUsername

		update =
			$set:
				"usernames.$": username

		return @update query, update, { multi: true }


	# PUSH
	pushWebrtcJoined: (_id, user) ->
		user.ts = new Date()
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				webrtcJoined: user
		return @update query, update

	pushTag: (_id, tag) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				tags: tag
		return @update query, update

	pushShareById: (_id, share) ->
		share = _.extend share, {ts: new Date()}
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				share: share

		return @update query, update

	pushReadById: (_id, read) ->
		read = _.extend read, {ts: new Date()}
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				read: read

		return @update query, update

	pushCommentById: (_id, comment) ->
		comment = _.extend comment, {commentAt: new Date()}
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				comment: comment

		return @update query, update

	pushInviteById: (_id, invite) ->
		invite = _.extend invite, {inviteAt: new Date()}
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				invite: invite

		return @update query, update

	pushFavoriteById: (_id, favorite) ->
		favorite = _.extend favorite, {favoriteAt: new Date()}
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				favorite: favorite

		return @update query, update

	pushSupportById: (_id, support) ->
		support = _.extend support, {supportedAt: new Date()}
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				support: support

		return @update query, update

	pushCommentById: (_id, comment) ->
		comment = _.extend comment, {commentAt: new Date()}
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$push: 
				comment: comment

		return @update query, update

	# PULL ONE
	pullFavoriteById: (_id, favorite) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$pull: 
				favorite: favorite

		return @update query, update

	pullInviteById: (_id, invite) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$pull: 
				invite: invite

		return @update query, update

	pullTag: (_id, tag) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$pull: 
				tags: tag
		return @update query, update

	pullWebrtcJoined: (_id, user) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		update =
			$pull: 
				webrtcJoined: user
		return @update query, update

	removeAllWebrtcJoined: (_id) ->
		query = 
			_id: _id
			del: {
				$ne: true
			}
		update = 
			$set:
				webrtcJoined: []
				
		return @update query, update

	incReadCount: (_id) ->
		query = 
			_id: _id
			del: {
				$ne: true
			}
		update = 
			$inc: 
				readCount: 1
				
		return @update query, update
	

	# INSERT
	createDebate: (option) ->
		record = {
			ts: new Date()
			del: false
			_hidden: false
			webrtcJoined: []
			read: []
			readCount: 0
			share: []
			shareCount: 0
			favorite: []
		}
		record = _.extend record, option

		if record._id
			if record?.rid?
				return @upsert record._id, record
			else
				return @update record._id, {$set: record}
		else
			_id = @insert record
			return {_id: _id}


	# REMOVE(service不允许调用，remove使用update)
	removeById: (_id) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		return @remove query

	removeByUserId: (uid) ->
		query =
			"u._id": userId

		return @remove query
