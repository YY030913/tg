TAGT.Migrations.add
	version: 16
	up: ->
		TAGT.models.Messages.tryDropIndex({ _hidden: 1 })
