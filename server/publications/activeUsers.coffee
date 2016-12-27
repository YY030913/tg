Meteor.publish 'activeUsers', ->
	unless this.userId
		return this.ready()

	TAGT.models.Users.findUsersNotOffline
		fields:
			username: 1
			status: 1
			utcOffset: 1
