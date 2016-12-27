TAGT.AdminBox.addOption
	href: 'admin-integrations'
	i18nLabel: 'Integrations'
	permissionGranted: ->
		return TAGT.authz.hasAtLeastOnePermission(['manage-integrations', 'manage-own-integrations'])
