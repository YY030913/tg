Meteor.publish 'userData', ->
	unless this.userId
		return this.ready()

	TAGT.models.Users.find this.userId,
		fields:
			name: 1
			username: 1
			status: 1
			statusDefault: 1
			statusConnection: 1
			avatarOrigin: 1
			utcOffset: 1
			language: 1
			settings: 1
			roles: 1
			active: 1
			defaultRoom: 1
			'services.github': 1
			'services.gitlab': 1
			requirePasswordChange: 1
			requirePasswordChangeReason: 1
			'services.password.bcrypt': 1
			statusLivechat: 1 # @TODO create an API so a package could add fields here

			createdAt: 1
			'services.facebook': 1
			'services.weibo': 1
			'services.wechat': 1
			'services.google': 1
			score: 1
			medals: 1
			debates: 1
			createDebates: 1
			shortCountry: 1
			introduction: 1
			