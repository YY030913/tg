Meteor.methods
	setShortCountry: (shorCountry) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'setShortCountry' })

		user = Meteor.user()

		if user.shorCountry? and not TAGT.settings.get("Accounts_AllowshorCountryChange")
			throw new Meteor.Error('error-not-allowed', "Not allowed", { method: 'setShortCountry' })

		if user.shorCountry is shorCountry
			return shorCountry

		changeCount = TAGT.models.Users.setShortCountry Meteor.userId(), shorCountry

		unless changeCount > 0
			throw new Meteor.Error 'error-could-not-change-shorCountry', "Could not change shorCountry", { method: 'setShortCountry' }
		

		activity = TAGT.Activity.utils.add('ShorCountry', null, 'changeShortCountry', 'changeShortCountry', null)
		activity.userId = Meteor.userId()
		TAGT.models.Activity.createActivity(activity)

		return shorCountry