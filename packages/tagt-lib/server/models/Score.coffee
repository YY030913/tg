TAGT.models.Score = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'score'


	findOneByQuery: (query, options) ->
		query = _.extend query, {del: {
			$ne: true
		}}
		return @findOne query, options

	# FIND
	findByUserId: (userId, customQuery, options) ->
		query =
			userId: userId
			del: {
				$ne: true
			}
		query = _.extend query, customQuery
		return @find query, options

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
			ts: new Date()
			del: false
		}
		record = _.extend record, option

		TAGT.models.Users.incScore option.userId, option.score
		if option.userId
			user = TAGT.models.Users.findOneById(option.userId)
			
			if user.score >= 500 && user.score < 1000 && _.indexOf(user.medals, 'Medal_LEVEL_1') < 0
				TAGT.models.Users.addMedalsByUserId option.userId, "Medal_LEVEL_1"
			else if user.score >= 1000 && user.score < 3000 && _.indexOf(user.medals, 'Medal_LEVEL_2') < 0
				TAGT.models.Users.addMedalsByUserId option.userId, "Medal_LEVEL_2"
			else if user.score >= 3000 && user.score < 10000 && _.indexOf(user.medals, 'Medal_LEVEL_3') < 0
				TAGT.models.Users.addMedalsByUserId option.userId, "Medal_LEVEL_3"
			else if user.score >= 10000 && user.score < 20000 && _.indexOf(user.medals, 'Medal_LEVEL_4') < 0
				TAGT.models.Users.addMedalsByUserId option.userId, "Medal_LEVEL_4"
			else if user.score >= 20000 && user.score < 50000 && _.indexOf(user.medals, 'Medal_LEVEL_5') < 0
				TAGT.models.Users.addMedalsByUserId option.userId, "Medal_LEVEL_5"
			else if user.score >= 50000 && user.score < 100000 && _.indexOf(user.medals, 'Medal_LEVEL_6') < 0
				TAGT.models.Users.addMedalsByUserId option.userId, "Medal_LEVEL_6"
			else if user.score >= 100000 && _.indexOf(user.medals, 'Medal_LEVEL_7') < 0
				TAGT.models.Users.addMedalsByUserId option.userId, "Medal_LEVEL_7"

			if option.operator =="Create_Debae" && _.indexOf(user.medals, 'Medal_Engineer') < 0
				TAGT.models.Users.addMedalsByUserId option.userId, "Medal_Engineer"

		return @insert record


	removeByUserId: (uid) ->
		query =
			userId: userId

		return @remove query