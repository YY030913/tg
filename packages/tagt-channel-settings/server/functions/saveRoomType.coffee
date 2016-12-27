TAGT.saveRoomType = (rid, roomType) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'TAGT.saveRoomType' }

	if roomType not in ['c', 'p']
		throw new Meteor.Error 'error-invalid-room-type', 'error-invalid-room-type', { type: roomType }

	return TAGT.models.Rooms.setTypeById(rid, roomType) and TAGT.models.Subscriptions.updateTypeByRoomId(rid, roomType)
