Meteor.methods
	searchDebates: (name, end=null) ->
		
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'searchDebates' })

		user = TAGT.models.Users.findOneById Meteor.userId(), fields: _id:1, username: 1

		if not name
			return false

		temp = TAGT.models.Searchs.findOneByUserAndName(Meteor.userId(), name)

		if !temp?
			search = {}
			search.name = name
			search.u = user
			TAGT.models.Searchs.createSearch(search)
		else
			TAGT.models.Searchs.incSearchCount(Meteor.userId(), name)

		if end?
			debates = TAGT.models.Debates.find(
				name: { $regex : new RegExp("^.*#{name}.*$", "i") }
				ts: 
					$lt: end
			).fetch()
		else
			debates = TAGT.models.Debates.find(
				name: { $regex : new RegExp("^.*#{name}.*$", "i") }
			).fetch()

		return {
			debates: debates
		}
# Limit a user to sending 5 msgs/second
# DDPRateLimiter.addRule
# 	type: 'method'
# 	name: 'sendMessage'
# 	userId: (userId) ->
# 		return TAGT.models.Users.findOneById(userId)?.username isnt TAGT.settings.get('InternalHubot_Username')
# , 5, 1000

