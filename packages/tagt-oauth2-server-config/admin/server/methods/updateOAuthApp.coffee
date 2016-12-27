Meteor.methods
	updateOAuthApp: (applicationId, application) ->
		if not TAGT.authz.hasPermission @userId, 'manage-oauth-apps'
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'updateOAuthApp' }

		if not _.isString(application.name) or application.name.trim() is ''
			throw new Meteor.Error 'error-invalid-name', 'Invalid name', { method: 'updateOAuthApp' }

		if not _.isString(application.redirectUri) or application.redirectUri.trim() is ''
			throw new Meteor.Error 'error-invalid-redirectUri', 'Invalid redirectUri', { method: 'updateOAuthApp' }

		if not _.isBoolean(application.active)
			throw new Meteor.Error 'error-invalid-arguments', 'Invalid arguments', { method: 'updateOAuthApp' }

		currentApplication = TAGT.models.OAuthApps.findOne(applicationId)
		if not currentApplication?
			throw new Meteor.Error 'error-application-not-found', 'Application not found', { method: 'updateOAuthApp' }

		TAGT.models.OAuthApps.update applicationId,
			$set:
				name: application.name
				active: application.active
				redirectUri: application.redirectUri
				_updatedAt: new Date
				_updatedBy: TAGT.models.Users.findOne @userId, {fields: {username: 1}}

		return TAGT.models.OAuthApps.findOne(applicationId)
