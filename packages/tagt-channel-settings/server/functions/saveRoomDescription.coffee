TAGT.saveRoomDescription = (rid, roomDescription, user) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'TAGT.saveRoomDescription' }

	roomDescription = s.escapeHTML(roomDescription)

	update = TAGT.models.Rooms.setDescriptionById rid, roomDescription

	TAGT.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser 'room_changed_description', rid, roomDescription, user

	return update
