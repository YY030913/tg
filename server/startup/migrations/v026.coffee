TAGT.Migrations.add
	version: 26
	up: ->
		TAGT.models.Messages.update({ t: 'rm' }, { $set: { mentions: [] } }, { multi: true })
