TAGT.Migrations.add
	version: 23
	up: ->
		TAGT.models.Settings.remove { _id: 'Accounts_denyUnverifiedEmails' }
		console.log 'Deleting not used setting Accounts_denyUnverifiedEmails'
