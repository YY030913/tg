TAGT.authz.removeUserFromRoles = (userId, roleNames, scope) ->
	if not userId or not roleNames
		return false

	user = TAGT.models.Users.findOneById(userId)
	if not user?
		throw new Meteor.Error 'error-invalid-user', 'Invalid user', { function: 'TAGT.authz.removeUserFromRoles' }

	roleNames = [].concat roleNames

	existingRoleNames = _.pluck(TAGT.authz.getRoles(), '_id')
	invalidRoleNames = _.difference(roleNames, existingRoleNames)
	unless _.isEmpty(invalidRoleNames)
		throw new Meteor.Error 'error-invalid-role', 'Invalid role', { function: 'TAGT.authz.removeUserFromRoles' }

	TAGT.models.Roles.removeUserRoles(userId, roleNames, scope)

	return true
