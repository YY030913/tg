TAGT.authz.hasRole = (userId, roleNames, scope) ->
	roleNames = [].concat roleNames
	return TAGT.models.Roles.isUserInRoles(userId, roleNames, scope) # true if user is in ANY role
