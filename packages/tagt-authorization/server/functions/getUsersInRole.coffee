TAGT.authz.getUsersInRole = (roleName, scope, options) ->
	return TAGT.models.Roles.findUsersInRole(roleName, scope, options)
