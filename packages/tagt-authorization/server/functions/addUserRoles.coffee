TAGT.authz.addUserRoles = (userId, roleNames, scope) ->
	if not userId or not roleNames
		return false

	user = TAGT.models.Users.findOneById(userId)
	if not user
		throw new Meteor.Error 'error-invalid-user', 'Invalid user', { function: 'TAGT.authz.addUserRoles' }

	roleNames = [].concat roleNames

	existingRoleNames = _.pluck(TAGT.authz.getRoles(), '_id')
	invalidRoleNames = _.difference(roleNames, existingRoleNames)
	unless _.isEmpty(invalidRoleNames)
		for role in invalidRoleNames
			TAGT.models.Roles.createOrUpdate role

	TAGT.models.Roles.addUserRoles(userId, roleNames, scope)

	return true
