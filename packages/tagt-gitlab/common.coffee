config =
	serverURL: 'https://gitlab.com'
	identityPath: '/api/v3/user'
	scope: 'api'
	addAutopublishFields:
		forLoggedInUser: ['services.gitlab']
		forOtherUsers: ['services.gitlab.username']

Gitlab = new CustomOAuth 'gitlab', config

if Meteor.isServer
	Meteor.startup ->
		TAGT.models.Settings.findById('API_Gitlab_URL').observe
			added: (record) ->
				config.serverURL = TAGT.settings.get 'API_Gitlab_URL'
				Gitlab.configure config
			changed: (record) ->
				config.serverURL = TAGT.settings.get 'API_Gitlab_URL'
				Gitlab.configure config
else
	Meteor.startup ->
		Tracker.autorun ->
			if TAGT.settings.get 'API_Gitlab_URL'
				config.serverURL = TAGT.settings.get 'API_Gitlab_URL'
				Gitlab.configure config
