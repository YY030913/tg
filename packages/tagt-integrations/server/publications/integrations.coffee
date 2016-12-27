Meteor.publish 'integrations', ->
	unless @userId
		return @ready()

	if TAGT.authz.hasPermission @userId, 'manage-integrations'
		return TAGT.models.Integrations.find()
	else if TAGT.authz.hasPermission @userId, 'manage-own-integrations'
		return TAGT.models.Integrations.find({"_createdBy._id": @userId})
	else
		throw new Meteor.Error "not-authorized"
