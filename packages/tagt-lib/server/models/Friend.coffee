TAGT.models.Friend = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'friend'

	# FIND
	findByUser: (userId, options) ->
		query =
			"u._id": userId
			del: {
				$ne: true
			}

		return @find query, options

	findByOneDel: (userId, frienId, options) ->
		query =
			"u._id": userId
			"friend._id": frienId
			del: true

		return @findOne query, options

	findByOne: (userId, frienId, options) ->
		query =
			"u._id": userId
			"friend._id": frienId
			del: {
				$ne: true
			}

		return @findOne query, options

	findByUser: (userId, option) ->
		query = {
			"u._id": userId
			del: {
				$ne: true
			}
		}
		return @find query, option

	findByFriend: (frienId, option) ->
		query = {
			"friend._id": frienId
			del: {
				$ne: true
			}
		}
		return @find query, option


	# INSERT
	createFriend: (option) ->
		record = {
			del: false
		}
		record = _.extend record, option

		return @insert record


	# update
	delFriend: (userId, frienId) ->
		query =
			"u._id": userId
			"friend._id": frienId
			del: {
				$ne: true
			}

		record = {
			$set:
				del: true
			$push:
				delete: 
					ts: new  Date()
		}

		return @update query, record

	refollowFriend: (userId, frienId) ->
		query =
			"u._id": userId
			"friend._id": frienId

		record = {
			$set:
				del: false
			$push:
				follow: 
					ts: new  Date()
		}

		return @update query, record

	removeByUserId: (userId) ->
		query =
			$or: [
				"u._id": userId
				"friend._id": userId
			]
			

		return @remove query