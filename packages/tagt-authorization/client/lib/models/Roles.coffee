TAGT.models.Roles = new Meteor.Collection 'tagt_roles'

TAGT.models.Roles.findUsersInRole = (name, scope, options) ->
	role = @findOne name
	roleScope = role?.scope or 'Users'
	TAGT.models[roleScope]?.findUsersInRoles?(name, scope, options)

TAGT.models.Roles.isUserInRoles = (userId, roles, scope) ->
	roles = [].concat roles
	_.some roles, (roleName) =>
		role = @findOne roleName
		roleScope = role?.scope or 'Users'
		return TAGT.models[roleScope]?.isUserInRole?(userId, roleName, scope)

