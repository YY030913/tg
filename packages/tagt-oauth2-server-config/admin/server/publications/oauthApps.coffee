Meteor.publish 'oauthApps', ->
	unless @userId
		return @ready()

	if not TAGT.authz.hasPermission @userId, 'manage-oauth-apps'
		@error Meteor.Error "error-not-allowed", "Not allowed", { publish: 'oauthApps' }

	return TAGT.models.OAuthApps.find()
