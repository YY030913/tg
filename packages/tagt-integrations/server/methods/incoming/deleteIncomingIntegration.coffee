Meteor.methods
	deleteIncomingIntegration: (integrationId) ->
		integration = null

		if TAGT.authz.hasPermission @userId, 'manage-integrations'
			integration = TAGT.models.Integrations.findOne(integrationId)
		else if TAGT.authz.hasPermission @userId, 'manage-own-integrations'
			integration = TAGT.models.Integrations.findOne(integrationId, { fields : {"_createdBy._id": @userId} })
		else
			throw new Meteor.Error 'not_authorized'

		if not integration?
			throw new Meteor.Error 'error-invalid-integration', 'Invalid integration', { method: 'deleteIncomingIntegration' }

		TAGT.models.Integrations.remove _id: integrationId

		return true
