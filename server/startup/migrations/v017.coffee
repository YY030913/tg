TAGT.Migrations.add
	version: 17
	up: ->
		TAGT.models.Messages.tryDropIndex({ _hidden: 1 })
