TAGT.Migrations.add
	version: 27
	up: ->
		TAGT.models.Users.update({}, { $rename: { roles: '_roles' } }, { multi: true })

		TAGT.models.Users.find({ _roles: { $exists: 1 } }).forEach (user) ->
			for scope, roles of user._roles
				TAGT.models.Roles.addUserRoles(user._id, roles, scope)

		TAGT.models.Users.update({}, { $unset: { _roles: 1 } }, { multi: true })
