TAGT.models.Roles = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'roles'
		@tryEnsureIndex { 'name': 1 }
		@tryEnsureIndex { 'scope': 1 }

	findUsersInRole: (name, scope, options) ->
		role = @findOne name
		roleScope = role?.scope or 'Users'
		TAGT.models[roleScope]?.findUsersInRoles?(name, scope, options)

	isUserInRoles: (userId, roles, scope) ->
		roles = [].concat roles
		_.some roles, (roleName) =>
			role = @findOne roleName
			roleScope = role?.scope or 'Users'
			return TAGT.models[roleScope]?.isUserInRole?(userId, roleName, scope)

	createOrUpdate: (name, scope, description, protectedRole) ->
		scope ?= 'Users'
		updateData = {}
		updateData.name = name
		updateData.scope = scope
		if description?
			updateData.description = description
		if protectedRole?
			updateData.protected = protectedRole

		@upsert { _id: name }, { $set: updateData }

	addUserRoles: (userId, roles, scope) ->
		roles = [].concat roles
		for roleName in roles
			role = @findOne roleName
			roleScope = role?.scope or 'Users'
			TAGT.models[roleScope]?.addRolesByUserId?(userId, roleName, scope)

	removeUserRoles: (userId, roles, scope) ->
		roles = [].concat roles
		for roleName in roles
			role = @findOne roleName
			roleScope = role?.scope or 'Users'
			TAGT.models[roleScope]?.removeRolesByUserId?(userId, roleName, scope)
