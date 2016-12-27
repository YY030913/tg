Meteor.methods
	setUsername: (username) ->

		check username, String

		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'setUsername' })

		user = Meteor.user()

		if user.username? and not TAGT.settings.get("Accounts_AllowUsernameChange")
			throw new Meteor.Error('error-not-allowed', "Not allowed", { method: 'setUsername' })

		if user.username is username
			return username

		try
			nameValidation = new RegExp '^' + TAGT.settings.get('UTF8_Names_Validation') + '$'
		catch
			nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

		if not nameValidation.test username
			throw new Meteor.Error 'username-invalid', "#{_.escape(username)} is not a valid username, use only letters, numbers, dots, hyphens and underscores"

		if user.username != undefined
			if not username.toLowerCase() == user.username.toLowerCase()
				if not  TAGT.checkUsernameAvailability username
					throw new Meteor.Error 'error-field-unavailable', "<strong>" + _.escape(username) + "</strong> is already in use :(", { method: 'setUsername', field: username }
		else
			if not  TAGT.checkUsernameAvailability username
				throw new Meteor.Error 'error-field-unavailable', "<strong>" + _.escape(username) + "</strong> is already in use :(", { method: 'setUsername', field: username }

		unless TAGT.setUsername user._id, username
			throw new Meteor.Error 'error-could-not-change-username', "Could not change username", { method: 'setUsername' }


		_.each(TAGT.models.Tags.find({t: 'o'}, {fields: {_id: 1, name: 1, ts: 1, t: 1}}).fetch(), (element, index, list)->
			ds = TAGT.models.DebateSubscriptions.findOneByTagIdAndUserId element._id, user._id
			if !ds?
				TAGT.models.DebateSubscriptions.createWithTagAndUser element, {_id: user._id, username: username}
		)

		activity = TAGT.Activity.utils.add('Username_title', null, 'register', 'register', null)
		activity.userId = this.userId
		TAGT.models.Activity.createActivity(activity)

		return username

TAGT.RateLimiter.limitMethod 'setUsername', 1, 1000,
	userId: (userId) -> return true
