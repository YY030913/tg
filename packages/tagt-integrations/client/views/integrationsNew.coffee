Template.integrationsNew.helpers
	hasPermission: ->
		return TAGT.authz.hasAtLeastOnePermission(['manage-integrations', 'manage-own-integrations'])
