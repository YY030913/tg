Meteor.publish 'pointUserData', (userId) ->
	unless userId
		return this.ready()

	TAGT.models.Users.find userId,
		fields:
			name: 1
			username: 1
			status: 1
			statusDefault: 1
			statusConnection: 1
			avatarOrigin: 1
			utcOffset: 1
			language: 1
			'services.wechat': 1
			'services.google': 1
			statusLivechat: 1 # @TODO create an API so a package could add fields here
			score: 1
