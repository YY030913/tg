Meteor.methods
	loadUserDebates: (userId, end, limit=20, ls=null) ->
		if ls?
			unless Meteor.userId()
				return this.ready()


		options =
			sort:
				ts: -1
			limit: limit

		if end?
			records = TAGT.models.Debates.findByUserAfterTime(userId, end, options).fetch()
		else
			records = TAGT.models.Debates.findByUser(userId, options).fetch()
			
		return {
			debates: records
		}