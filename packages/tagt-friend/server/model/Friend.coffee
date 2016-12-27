TAGT.models.Friend = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'friend'

	# FIND
	findByUser: (userId, options) ->
		query =
			userId: userId
			del: {
				$ne: true
			}

		return @find query, options

	findByOne: (userId, frienId) ->
		query =
			userId: userId
			frienId: frienId
			del: {
				$ne: true
			}

		return @find query, options


	# INSERT
	createFriend: (option) ->
		record = {
			ts: new Date()
			del: false
		}
		record = _.extend record, option

		return @insert record
