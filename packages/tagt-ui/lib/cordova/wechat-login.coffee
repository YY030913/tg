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
		scope = "snsapi_userinfo"
		newDate = +new Date()
		state = "_#{newDate}"
		Wechat.auth scope, state, fbLoginSuccess, (error) ->
			callback(error)

	else
		Wechat.requestCredential(options, credentialRequestCompleteCallback)