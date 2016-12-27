atLeastOne = (userId, permissions, scope) ->
	return _.some permissions, (permissionId) ->
		permission = TAGT.models.Permissions.findOne permissionId
		TAGT.models.Roles.isUserInRoles(userId, permission.roles, scope)

all = (userId, permissions, scope) ->
	return _.every permissions, (permissionId) ->
		permission = TAGT.models.Permissions.findOne permissionId
		TAGT.models.Roles.isUserInRoles(userId, permission.roles, scope)

hasPermission = (userId, permissions, scope, strategy) ->
	unless userId
		return false

	permissions = [].concat permissions
	return strategy(userId, permissions, scope)



TAGT.authz.hasAllPermission = (userId, permissions, scope) ->
	return hasPermission(userId, permissions, scope, all)

TAGT.authz.hasPermission = TAGT.authz.hasAllPermission

TAGT.authz.hasAtLeastOnePermission = (userId, permissions, scope) ->
	return hasPermission(userId, permissions, scope, atLeastOne)
