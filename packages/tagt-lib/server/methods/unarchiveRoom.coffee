Meteor.methods
	unarchiveRoom: (rid) ->

		check rid, String

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'unarchiveRoom' }

		room = TAGT.models.Rooms.findOneById rid

		unless room
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'unarchiveRoom' }

		unless TAGT.authz.hasPermission(Meteor.userId(), 'unarchive-room', room._id)
			throw new Meteor.Error 'error-not-authorized', 'Not authorized', { method: 'unarchiveRoom' }

		TAGT.unarchiveRoom(rid);
