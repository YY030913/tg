Meteor.subscribe 'roles'

TAGT.AdminBox.addOption
	href: 'admin-permissions'
	i18nLabel: 'Permissions'
	permissionGranted: ->
		return TAGT.authz.hasAllPermission('access-permissions')
