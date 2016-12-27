TAGT.Migrations.add
	version: 13
	up: ->
		# Set all current users as active
		TAGT.models.Users.setAllUsersActive true
		console.log "Set all users as active"
