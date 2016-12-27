TAGT.Migrations.add
	version: 24
	up: ->
		TAGT.models.Permissions.remove({ _id: 'access-rocket-permissions' })
