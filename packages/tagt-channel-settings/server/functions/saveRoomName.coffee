TAGT.saveRoomName = (rid, name, user) ->
	room = TAGT.models.Rooms.findOneById rid

	if room.t not in ['c', 'p']
		throw new Meteor.Error 'error-not-allowed', 'Not allowed', { function: 'TAGT.saveRoomName' }

	try
		nameValidation = new RegExp '^' + TAGT.settings.get('UTF8_Names_Validation') + '$'
	catch
		nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

	if not nameValidation.test name
		throw new Meteor.Error 'error-invalid-room-name', name + ' is not a valid room name. Use only letters, numbers, hyphens and underscores', { function: 'TAGT.saveRoomName', room_name: name }


	# name = _.slugify name

	if name is room.name
		return

	# avoid duplicate names
	if TAGT.models.Rooms.findOneByName name
		throw new Meteor.Error 'error-duplicate-channel-name', 'A channel with name \'' + name + '\' exists', { function: 'TAGT.saveRoomName', channel_name: name }

	TAGT.models.Rooms.setNameById rid, name
	TAGT.models.Subscriptions.updateNameAndAlertByRoomId rid, name

	return name
