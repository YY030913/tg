TAGT.AdminBox.addOption
	href: 'mailer'
	i18nLabel: 'Mailer'
	permissionGranted: ->
		return TAGT.authz.hasAllPermission('access-mailer')
