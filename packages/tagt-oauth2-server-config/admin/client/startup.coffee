TAGT.AdminBox.addOption
	href: 'admin-oauth-apps'
	i18nLabel: 'OAuth Apps'
	permissionGranted: ->
		return TAGT.authz.hasAllPermission('manage-oauth-apps')
