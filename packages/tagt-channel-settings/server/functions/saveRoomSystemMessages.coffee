TAGT.saveRoomSystemMessages = (rid, systemMessages, user) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'TAGT.saveRoomSystemMessages' }

	update = TAGT.models.Rooms.setSystemMessagesById rid, systemMessages

	return update
