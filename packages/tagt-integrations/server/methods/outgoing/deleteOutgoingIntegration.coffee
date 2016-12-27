Meteor.methods
	deleteOutgoingIntegration: (integrationId) ->
		integration = null

		if TAGT.authz.hasPermission(@userId, 'manage-integrations') or TAGT.authz.hasPermission(@userId, 'manage-integrations', 'bot')
			integration = TAGT.models.Integrations.findOne(integrationId)
		else if TAGT.authz.hasPermission(@userId, 'manage-own-integrations') or TAGT.authz.hasPermission(@userId, 'manage-own-integrations', 'bot')
			integration = TAGT.models.Integrations.findOne(integrationId, { fields : {"_createdBy._id": @userId} })
		else
			throw new Meteor.Error 'not_authorized'

		if not integration?
			throw new Meteor.Error 'error-invalid-integration', 'Invalid integration', { method: 'deleteOutgoingIntegration' }

		TAGT.models.Integrations.remove _id: integrationId

		return true
