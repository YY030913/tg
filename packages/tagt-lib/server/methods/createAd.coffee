Meteor.methods
	createAd: (adData) ->
	
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createAd' }

		if TAGT.authz.hasPermission(Meteor.userId(), 'create-ad') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'createAd' }

		user = Meteor.user()

		ad = 
			u:
				_id: user._id
				username: user.username

		if adData.name?
			ad._id = adData.name
		if adData.cover?
			ad.cover = adData.cover
		if adData.url?
			ad.url = adData.url

		TAGT.callbacks.run 'beforeCreateAd', ad

		update = TAGT.models.Ad.createAd ad

		ad._id = update.insertedId or update
		
		TAGT.callbacks.run 'afterCreateAd', ad
		return ad._id