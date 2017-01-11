Meteor.methods
	canAccessRoom: (rid, userId) ->

		check rid, String
		check userId, String

		user = TAGT.models.Users.findOneById userId, fields: username: 1

		unless user?.username
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'canAccessRoom' }

		unless rid
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'canAccessRoom' }

		room = TAGT.models.Rooms.findOneById rid

		if room
			if TAGT.authz.canAccessRoom.call(this, room, user)
				console.log "yes"
				room.username = user.username
				return room
			else
				console.log "no"
				return false
		else
			console.log "error"
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'canAccessRoom' }
