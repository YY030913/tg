TAGT.saveRoomTopic = (rid, roomTopic, user) ->
	unless Match.test rid, String
		throw new Meteor.Error 'invalid-room', 'Invalid room', { function: 'TAGT.saveRoomTopic' }

	roomTopic = s.escapeHTML(roomTopic)

	update = TAGT.models.Rooms.setTopicById(rid, roomTopic)

	return update
