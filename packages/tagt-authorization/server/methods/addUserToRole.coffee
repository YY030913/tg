Meteor.methods
	'authorization:addUserToRole': (roleName, username, scope) ->
		if not Meteor.userId() or not TAGT.authz.hasPermission Meteor.userId(), 'access-permissions'
			throw new Meteor.Error "error-action-not-allowed", "Accessing permissions is not allowed", { method: 'authorization:addUserToRole', action: 'Accessing_permissions' }

		if not roleName or not _.isString(roleName) or not username or not _.isString(username)
			throw new Meteor.Error 'error-invalid-arguments', 'Invalid arguments', { method: 'authorization:addUserToRole' }

		if roleName is 'admin' and not TAGT.authz.hasPermission Meteor.userId(), 'assign-admin-role'
			throw new Meteor.Error 'error-action-not-allowed', 'Assigning admin is not allowed', { method: 'insertOrUpdateUser', action: 'Assign_admin' }

		user = TAGT.models.Users.findOneByUsername username, { fields: { _id: 1 } }

		if not user?._id?
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'authorization:addUserToRole' }

		add = TAGT.models.Roles.addUserRoles user._id, roleName, scope

		if TAGT.settings.get('UI_DisplayRoles')
			TAGT.Notifications.notifyAll('roles-change', { type: 'added', _id: roleName, u: { _id: user._id, username: username }, scope: scope });

		return add
