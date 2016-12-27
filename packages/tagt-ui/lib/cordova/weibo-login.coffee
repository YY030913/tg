Meteor.loginWithWeiboCordova = (options, callback) ->
	if not callback and typeof options is "function"
		callback = options
		options = null

	credentialRequestCompleteCallback = Accounts.oauth.credentialRequestCompleteHandler(callback)

	fbLoginSuccess = (data) ->
		data.cordova = true
		data.service = "weibo"

		Accounts.callLoginMethod
			methodArguments: [data]
			userCallback: callback

	if typeof window.weibo isnt "undefined"

		window.weibo.login fbLoginSuccess, (error) ->
			console.log('login', JSON.stringify(error), error)
			callback(error)

	else
		Weibo.requestCredential(options, credentialRequestCompleteCallback)