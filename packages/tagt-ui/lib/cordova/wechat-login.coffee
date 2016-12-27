Meteor.loginWithWechatCordova = (options, callback) ->
	if not callback and typeof options is "function"
		callback = options
		options = null

	credentialRequestCompleteCallback = Accounts.oauth.credentialRequestCompleteHandler(callback)

	fbLoginSuccess = (data) ->
		data.cordova = true
		data.service = "wechat"

		Accounts.callLoginMethod
			methodArguments: [data]
			userCallback: callback

	if typeof Wechat isnt "undefined"
		state = "_" + (+new Date())
		Wechat.auth "snsapi_userinfo", state, fbLoginSuccess, (error) ->
			console.log('login', JSON.stringify(error), error)
			callback(error)

	else
		Google.requestCredential(options, credentialRequestCompleteCallback)