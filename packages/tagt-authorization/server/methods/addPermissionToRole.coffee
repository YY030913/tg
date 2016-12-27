Meteor.methods
	'authorization:addPermissionToRole': (permission, role) ->
		if not Meteor.userId() or not TAGT.authz.hasPermission Meteor.userId(), 'access-permissions'
			throw new Meteor.Error 'error-action-not-allowed', 'Adding permission is not allowed', { method: 'authorization:addPermissionToRole', action: 'Adding_permission' }

		TAGT.models.Permissions.addRole permission, role
