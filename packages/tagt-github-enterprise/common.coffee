# GitHub Enterprise Server CallBack URL needs to be http(s)://{tagt.server}[:port]/_oauth/github_enterprise
# In TAGT -> Administration the URL needs to be http(s)://{github.enterprise.server}/
config =
	serverURL: ''
	identityPath: '/api/v3/user'
	authorizePath: '/login/oauth/authorize'
	tokenPath: '/login/oauth/access_token'
	addAutopublishFields:
		forLoggedInUser: ['services.github-enterprise']
		forOtherUsers: ['services.github-enterprise.username']

GitHubEnterprise = new CustomOAuth 'github_enterprise', config

if Meteor.isServer
	Meteor.startup ->
		TAGT.models.Settings.findById('API_GitHub_Enterprise_URL').observe
			added: (record) ->
				config.serverURL = TAGT.settings.get 'API_GitHub_Enterprise_URL'
				GitHubEnterprise.configure config
			changed: (record) ->
				config.serverURL = TAGT.settings.get 'API_GitHub_Enterprise_URL'
				GitHubEnterprise.configure config
else
	Meteor.startup ->
		Tracker.autorun ->
			if TAGT.settings.get 'API_GitHub_Enterprise_URL'
				config.serverURL = TAGT.settings.get 'API_GitHub_Enterprise_URL'
				GitHubEnterprise.configure config
