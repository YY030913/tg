Meteor.methods
	saveRoomSettings: (rid, setting, value) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { function: 'TAGT.saveRoomName' })

		unless Match.test rid, String
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'saveRoomSettings' }

		if setting not in ['roomName', 'roomTopic', 'roomDescription', 'roomType', 'readOnly', 'systemMessages', 'default', 'joinCode']
			throw new Meteor.Error 'error-invalid-settings', 'Invalid settings provided', { method: 'saveRoomSettings' }

		unless TAGT.authz.hasPermission(Meteor.userId(), 'edit-room', rid)
			throw new Meteor.Error 'error-action-not-allowed', 'Editing room is not allowed', { method: 'saveRoomSettings', action: 'Editing_room' }

		if setting is 'default' and not TAGT.authz.hasPermission(@userId, 'view-room-administration')
			throw new Meteor.Error 'error-action-not-allowed', 'Viewing room administration is not allowed', { method: 'saveRoomSettings', action: 'Viewing_room_administration' }

		room = TAGT.models.Rooms.findOneById rid
		if room?
			switch setting
				when 'roomName'
					name = TAGT.saveRoomName rid, value
					TAGT.models.Messages.createRoomRenamedWithRoomIdRoomNameAndUser rid, name, Meteor.user()
				when 'roomTopic'
					if value isnt room.topic
						TAGT.saveRoomTopic(rid, value, Meteor.user())
						TAGT.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser 'room_changed_topic', rid, value, Meteor.user()
				when 'roomDescription'
					if value isnt room.description
						TAGT.saveRoomDescription rid, value, Meteor.user()
				when 'roomType'
					if value isnt room.t
						TAGT.saveRoomType(rid, value, Meteor.user())
						if value is 'c'
							message = TAPi18n.__('Channel')
						else
							message = TAPi18n.__('Private_Group')
						TAGT.models.Messages.createRoomSettingsChangedWithTypeRoomIdMessageAndUser 'room_changed_privacy', rid, message, Meteor.user()
				when 'readOnly'
					if value isnt room.ro
						TAGT.saveRoomReadOnly rid, value, Meteor.user()
				when 'systemMessages'
					if value isnt room.sysMes
						TAGT.saveRoomSystemMessages rid, value, Meteor.user()
				when 'joinCode'
					TAGT.models.Rooms.setJoinCodeById rid, String(value)
				when 'default'
					TAGT.models.Rooms.saveDefaultById rid, value

		return { result: true, rid: room._id }
