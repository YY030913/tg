Meteor.loginWithGoogleCordova = (options, callback) ->
	if not callback and typeof options is "function"
		callback = options
		options = null

	credentialRequestCompleteCallback = Accounts.oauth.credentialRequestCompleteHandler(callback)

	fbLoginSuccess = (data) ->
		data.cordova = true
		data.service = "google"

		Accounts.callLoginMethod
			methodArguments: [data]
			userCallback: callback

	if typeof window.plugins.googleplus isnt "undefined"
		window.plugins.googleplus.login 
			'scopes': 'profile email'
			'offline': true, 
			'webClientId': '282710845697-rlerblta4drj4qqt7ugsq0jsg0h29j0g.apps.googleusercontent.com'
		, fbLoginSuccess, (error) ->
			console.log('login', JSON.stringify(error), error)
			callback(error)

	else
		Google.requestCredential(options, credentialRequestCompleteCallback)