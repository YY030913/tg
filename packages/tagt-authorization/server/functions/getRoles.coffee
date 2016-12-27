TAGT.authz.getRoles = ->
	return TAGT.models.Roles.find().fetch()
