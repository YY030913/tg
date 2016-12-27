TAGT.Migrations.add
	version: 28
	up: ->
		TAGT.models.Permissions.addRole 'view-c-room', 'bot'
