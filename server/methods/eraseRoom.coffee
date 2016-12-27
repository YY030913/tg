Meteor.methods
	eraseRoom: (rid) ->

		check rid, String

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'eraseRoom' }

		fromId = Meteor.userId()

		roomType = TAGT.models.Rooms.findOneById(rid)?.t

		if TAGT.authz.hasPermission( fromId, "delete-#{roomType}", rid )
			# ChatRoom.update({ _id: rid}, {'$pull': { userWatching: Meteor.userId(), userIn: Meteor.userId() }})

			TAGT.models.Messages.removeByRoomId rid
			TAGT.models.Subscriptions.removeByRoomId rid
			TAGT.models.Rooms.removeById rid
			# @TODO remove das mensagens lidas do usuário
		else
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'eraseRoom' }
