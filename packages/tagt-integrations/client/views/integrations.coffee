Template.integrations.helpers
	hasPermission: ->
		return TAGT.authz.hasAtLeastOnePermission(['manage-integrations', 'manage-own-integrations'])

	integrations: ->
		return ChatIntegrations.find()

	dateFormated: (date) ->
		return moment(date).format('L LT')
