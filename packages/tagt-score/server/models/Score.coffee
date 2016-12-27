TAGT.models.Score = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'score'

		@tryEnsureIndex { 'slug': 1 }, { unique: 1, sparse: 1 }
		@tryEnsureIndex { 'name': 1 }, { unique: 1, sparse: 1 }

	findOneByQuery: (query, options) ->
		query = _.extend query, {del: {
			$ne: true
		}}
		return @findOne query, options

	# FIND
	findByUserId: (userId, options) ->
		query =
			userId: userId
			del: {
				$ne: true
			}

		return @findOne query, options

	updateOrCreate: (userId, score, scoreNum) ->
		share = _.extend share, {sharedAt: new Date()}
		query =
			userId: userId
			del: {
				$ne: true
			}

		update =
			$inc: 
				score: scoreNum
			$push: 
				scoreOp: 
					operator: score
					ts: new Date()
					scoreNum: scoreNum

		return @update query, update

	# INSERT
	create: (option) ->
		record = {
			score: 0;
			ts: new Date()
			del: false
		}
		record = _.extend record, option

		return @insert record
