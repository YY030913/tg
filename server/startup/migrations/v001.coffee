TAGT.Migrations.add
	version: 1
	up: ->
		TAGT.models.Users.find({username: {$exists: false}, lastLogin: {$exists: true}}).forEach (user) ->
			username = generateSuggestion(user)
			if username? and username.trim() isnt ''
				TAGT.models.Users.setUsername user._id, username
			else
				console.log "User without username", JSON.stringify(user, null, ' ')
