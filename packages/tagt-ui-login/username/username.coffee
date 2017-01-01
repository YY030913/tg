Template.username.onCreated ->
	self = this
	self.username = new ReactiveVar

	Meteor.call 'getUsernameSuggestion', (error, username) ->
		self.username.set
			ready: true
			username: username
		Meteor.defer ->
			self.find('input').focus()

Template.username.helpers
	username: ->
		return Template.instance().username.get()

Template.username.events
	'focus .input-text input': (event) ->
		$(event.currentTarget).parents('.input-text').addClass('focus')

	'blur .input-text input': (event) ->
		if event.currentTarget.value is ''
			$(event.currentTarget).parents('.input-text').removeClass('focus')

	'submit #login-card': (event, instance) ->
		event.preventDefault()

		username = instance.username.get()
		username.empty = false
		username.error = false
		username.invalid = false
		instance.username.set(username)

		button = $(event.target).find('button.login')
		TAGT.Button.loading(button)

		value = $("input").val().trim()
		if value is ''
			username.empty = true
			instance.username.set(username)
			TAGT.Button.reset(button)
			return


		Meteor.call 'setUsername', value, (err, result) ->
			if err?
				if err.error is 'username-invalid'
					username.invalid = true
				else
					username.error = true
				username.username = value

				TAGT.Button.reset(button)
				instance.username.set(username)
				TAGT.callbacks.run('usernameSet')

				###
				if not err?
					Meteor.call 'joinDefaultChannels'
				###
			else
				Meteor.call 'getAvatarSuggestion', (error, avatars) ->
					avatar = {}
					if avatars?.google
						if avatars?.google.blob
							avatar.blob = avatars?.google.blob
							avatar.contentType = avatars?.google.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.google.url
							avatar.contentType = avatars?.google.contentType
							avatar?.service = "url"

					else if avatars?.facebook
						if avatars?.facebook.blob
							avatar.blob = avatars?.facebook.blob
							avatar.contentType = avatars?.facebook.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.facebook.url
							avatar.contentType = avatars?.facebook.contentType
							avatar?.service = "url"

					else if avatars?.weibo
						if avatars?.weibo.blob
							avatar.blob = avatars?.weibo.blob
							avatar.contentType = avatars?.weibo.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.weibo.url
							avatar.contentType = avatars?.weibo.contentType
							avatar?.service = "url"

					else if avatars?.wechat
						if avatars?.wechat.blob
							avatar.blob = avatars?.wechat.blob
							avatar.contentType = avatars?.wechat.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.wechat.url
							avatar.contentType = avatars?.wechat.contentType
							avatar?.service = "url"

					else if avatars?.gravatar
						if avatars?.gravatar.blob
							avatar.blob = avatars?.gravatar.blob
							avatar.contentType = avatars?.gravatar.contentType
							avatar?.service = "blob"
						else
							avatar.url = avatars?.gravatar.url
							avatar.contentType = avatars?.gravatar.contentType
							avatar?.service = "url"

					if avatar.url?
						Meteor.call 'setAvatarFromService', avatar?.url, '', 'url', (err) ->
							if err?.details?.timeToReset?
								toastr.error t('error-too-many-requests', { seconds: parseInt(err.details.timeToReset / 1000) })
						
					else if avatar.blob?
						Meteor.call 'setAvatarFromService', avatar?.blob, avatar?.contentType, "blob", (err) ->
							if err?.details?.timeToReset?
								toastr.error t('error-too-many-requests', { seconds: parseInt(err.details.timeToReset / 1000) })

