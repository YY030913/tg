TAGT.saveRoomReadOnly = (rid, readOnly, user) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'TAGT.saveRoomReadOnly' }

	update = TAGT.models.Rooms.setReadOnlyById rid, readOnly

	return update
