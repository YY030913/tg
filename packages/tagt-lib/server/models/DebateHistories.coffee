TAGT.models.DebateHistories = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'debate_histories'

	#status: 0：关闭永不可见，1：所有人可见，2：私密（通过指定slug访问）

	# FIND ONE

	findOneBySlug: (slug, options) ->

		query =
			_id: slug
			del: {
				$ne: true
			}

		return @findOne query, options

	findOneByQuery: (query, options) ->
		query = _.extend query, {del: {
			$ne: true
		}}
		return @findOne query, options

	# FIND
	findByUser: (user, options) ->
		query =
			user: user
			del: {
				$ne: true
			}

		return @find query, options

	findList: (query, options) ->
		query = _.extend query, {del: {
			$ne: true
		}}
		return @find query, options


	# INSERT
	createDebate: (option) ->
		if option._id
			option.did = option._id
			delete option._id

		record = {
			ts: new Date()
			del: false
		}

		record = _.extend record, option
		
		return @insert record


	# REMOVE(service不允许调用，remove使用update)
	removeById: (_id) ->
		query =
			_id: _id
			del: {
				$ne: true
			}

		return @remove query

	# update
	updateAllUsernamesByUserId: (userId, username) ->
		query =
			"u._id": userId

		update =
			$set:
				"u.username": username

		return @update query, update, { multi: true }
