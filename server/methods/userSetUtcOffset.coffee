Meteor.methods
	userSetUtcOffset: (utcOffset) ->

		check utcOffset, Number

		if not @userId?
			return

		@unblock()

		TAGT.models.Users.setUtcOffset @userId, utcOffset

DDPRateLimiter.addRule
	type: 'method'
	name: 'userSetUtcOffset'
	userId: -> return true
, 1, 60000
