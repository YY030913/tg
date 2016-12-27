config =
	serverURL: ''
	identityPath: '/oauth/me'
	addAutopublishFields:
		forLoggedInUser: ['services.wordpress']
		forOtherUsers: ['services.wordpress.user_login']

WordPress = new CustomOAuth 'wordpress', config

if Meteor.isServer
	Meteor.startup ->
		TAGT.models.Settings.find({ _id: 'API_Wordpress_URL' }).observe
			added: (record) ->
				config.serverURL = TAGT.settings.get 'API_Wordpress_URL'
				WordPress.configure config
			changed: (record) ->
				config.serverURL = TAGT.settings.get 'API_Wordpress_URL'
				WordPress.configure config
else
	Meteor.startup ->
		Tracker.autorun ->
			if TAGT.settings.get 'API_Wordpress_URL'
				config.serverURL = TAGT.settings.get 'API_Wordpress_URL'
				WordPress.configure config
