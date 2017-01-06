Accounts.registerLoginHandler (loginRequest) ->
	if not loginRequest.cordova
		return undefined
	
	console.log loginRequest

	if loginRequest.service == "facebook"
		loginRequest = loginRequest.authResponse
		identity = getFacebookIdentity(loginRequest.accessToken)

		serviceData =
			accessToken: loginRequest.accessToken
			expiresAt: (+new Date) + (1000 * loginRequest.expiresIn)

		whitelisted = ['id', 'email', 'name', 'first_name', 'last_name', 'link', 'username', 'gender', 'locale', 'age_range', 'picture']

		fields = _.pick(identity, whitelisted)
		_.extend(serviceData, fields)

		options = {profile: {}}
		profileFields = _.pick(identity, whitelisted)
		_.extend(options.profile, profileFields)

		return Accounts.updateOrCreateUserFromExternalService("facebook", serviceData, options)

	else if loginRequest.service == "weibo"
		identity = getWeiboIdentity(loginRequest.token, loginRequest.uid)

		serviceData =
			accessToken: loginRequest.token
			expiresAt: (+new Date) + (loginRequest.expire_at)

		whitelisted = ['id', 'name', 'screen_name', 'location', 'description', 'profile_url', 'followers_count', 'friends_count', 'verified', 'verified_reason', 'avatar_large']

		fields = _.pick(identity, whitelisted)
		_.extend(serviceData, fields)

		options = {profile: {}}
		profileFields = _.pick(identity, whitelisted)
		_.extend(options.profile, profileFields)

		return Accounts.updateOrCreateUserFromExternalService("weibo", serviceData, options)

	else if loginRequest.service == "google"
		serviceData =
			accessToken: loginRequest.token
			expiresAt: (+new Date) + (loginRequest.expire_at)

		whitelisted = ['userId', 'displayName', 'email', 'location', 'description', 'profile_url', 'followers_count', 'friends_count', 'verified', 'verified_reason', 'avatar_large']

		fields = _.pick(loginRequest, whitelisted)
		fields.id = fields.userId
		_.extend(serviceData, fields)

		options = {profile: {}}
		profileFields = _.pick(loginRequest, whitelisted)
		profileFields.id = profileFields.userId
		_.extend(options.profile, profileFields)

		return Accounts.updateOrCreateUserFromExternalService("google", serviceData, options)

	else if loginRequest.service == "wechat"
		at = getWechatAccessToken(loginRequest.code)

		userinfo = getWechatUnionID(at.access_token, at.openid)

		serviceData =
			accessToken: loginRequest.token
			expiresAt: (+new Date) + (loginRequest.expire_at)

		whitelisted = ['openid', 'nickname', 'sex', 'province', 'city', 'country', 'headimgurl', 'privilege', 'unionid']
		fields = _.pick(userinfo, whitelisted)
		fields.id = fields.openid
		_.extend(serviceData, fields)

		options = {profile: {}}
		profileFields = _.pick(userinfo, whitelisted)
		profileFields.id = profileFields.userId
		_.extend(options.profile, profileFields)

		return Accounts.updateOrCreateUserFromExternalService("wechat", serviceData, options)



getFacebookIdentity = (accessToken) ->
	try
		return HTTP.get("https://graph.facebook.com/me", {headers: {"Access-Control-Allow-Origin": "*"}, params: {access_token: accessToken}}).data

	catch err
		throw _.extend new Error("Failed to fetch identity from Facebook. " + err.message), {response: err.response}


getWeiboIdentity = (token, uid) ->
	try
		return HTTP.get("https://api.weibo.com/2/users/show.json",{params: {access_token: token,uid: uid}}).data

	catch err
		throw _.extend new Error("Failed to fetch identity from Weibo. " + err.message), {response: err.response}

# 需要scope登录授权，非Cordova中的登录
getWeiboEmail = (token) ->
	try
		return HTTP.get("https://api.weibo.com/2/account/profile/email.json",{params: {access_token: token}}).data

	catch err
		throw _.extend new Error("Failed to fetch identity from Weibo. " + err.message), {response: err.response}

# 获取用户个人信息（UnionID机制）
# https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=open1419317853&lang=zh_CN

# code: '011Npmvp1F6opo0t8fvp1cXbvp1Npmv9',
# state: '_1483624338538',
# country: 'CN',
# lang: 'zh_CN',
# cordova: true,
# service: 'wechat' 


# wx96f86a95cb3e67f1
# 74fdbe901c165d138e9f0c957e7092c5

getWechatAccessToken = (code) ->
	try
		return HTTP.get("https://api.weixin.qq.com/sns/oauth2/access_token", {params: {appid:"wx96f86a95cb3e67f1", secret: "74fdbe901c165d138e9f0c957e7092c5", code: code, grant_type: "authorization_code"}}).data

	catch err
		throw _.extend new Error("Failed to fetch identity from Weibo. " + err.message), {response: err.response}

getWechatUnionID = (accesstoken, openid) ->
	try
		return HTTP.get("https://api.weixin.qq.com/sns/userinfo", {params: {access_token: accesstoken, openid: openid}}).data

	catch err
		throw _.extend new Error("Failed to fetch identity from Weibo. " + err.message), {response: err.response}

#http://m.2cto.com/weixin/201604/499478.html
#http://mp.weixin.qq.com/wiki/14/bb5031008f1494a59c6f71fa0f319c66.html
#微信 https://api.weixin.qq.com/sns/oauth2/

