Meteor.methods
	updateIncomingIntegration: (integrationId, integration) ->
		if not _.isString(integration.channel)
			throw new Meteor.Error 'error-invalid-channel', 'Invalid channel', { method: 'updateIncomingIntegration' }

		if integration.channel.trim() is ''
			throw new Meteor.Error 'error-invalid-channel', 'Invalid channel', { method: 'updateIncomingIntegration' }

		channels = _.map(integration.channel.split(','), (channel) -> s.trim(channel))

		for channel in channels
			if channel[0] not in ['@', '#']
				throw new Meteor.Error 'error-invalid-channel-start-with-chars', 'Invalid channel. Start with @ or #', { method: 'updateIncomingIntegration' }

		currentIntegration = null

		if TAGT.authz.hasPermission @userId, 'manage-integrations'
			currentIntegration = TAGT.models.Integrations.findOne(integrationId)
		else if TAGT.authz.hasPermission @userId, 'manage-own-integrations'
			currentIntegration = TAGT.models.Integrations.findOne({"_id": integrationId, "_createdBy._id": @userId})
		else
			throw new Meteor.Error 'not_authorized'

		if not currentIntegration?
			throw new Meteor.Error 'error-invalid-integration', 'Invalid integration', { method: 'updateIncomingIntegration' }

		if integration.scriptEnabled is true and integration.script? and integration.script.trim() isnt ''
			try
				babelOptions = Babel.getDefaultOptions({ runtime: false })
				babelOptions = _.extend(babelOptions, { compact: true, minified: true, comments: false })

				integration.scriptCompiled = Babel.compile(integration.script, babelOptions).code
				integration.scriptError = undefined
			catch e
				integration.scriptCompiled = undefined
				integration.scriptError = _.pick e, 'name', 'message', 'stack'

		for channel in channels
			record = undefined
			channelType = channel[0]
			channel = channel.substr(1)

			switch channelType
				when '#'
					record = TAGT.models.Rooms.findOne
						$or: [
							{_id: channel}
							{name: channel}
						]
				when '@'
					record = TAGT.models.Users.findOne
						$or: [
							{_id: channel}
							{username: channel}
						]

			if record is undefined
				throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'updateIncomingIntegration' }

			if record.usernames? and
			(not TAGT.authz.hasPermission @userId, 'manage-integrations') and
			(TAGT.authz.hasPermission @userId, 'manage-own-integrations') and
			Meteor.user()?.username not in record.usernames
				throw new Meteor.Error 'error-invalid-channel', 'Invalid Channel', { method: 'updateIncomingIntegration' }

		user = TAGT.models.Users.findOne({username: currentIntegration.username})
		TAGT.models.Roles.addUserRoles user._id, 'bot'

		TAGT.models.Integrations.update integrationId,
			$set:
				enabled: integration.enabled
				name: integration.name
				avatar: integration.avatar
				emoji: integration.emoji
				alias: integration.alias
				channel: channels
				script: integration.script
				scriptEnabled: integration.scriptEnabled
				scriptCompiled: integration.scriptCompiled
				scriptError: integration.scriptError
				_updatedAt: new Date
				_updatedBy: TAGT.models.Users.findOne @userId, {fields: {username: 1}}

		return TAGT.models.Integrations.findOne(integrationId)
