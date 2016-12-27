Meteor.methods
	pinMessage: (message, pinnedAt) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'pinMessage' })

		if not TAGT.settings.get 'Message_AllowPinning'
			throw new Meteor.Error 'error-action-not-allowed', 'Message pinning not allowed', { method: 'pinMessage', action: 'Message_pinning' }

		room = TAGT.models.Rooms.findOne({ _id: message.rid })

		if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
			return false

		# If we keep history of edits, insert a new message to store history information
		if TAGT.settings.get 'Message_KeepHistory'
			TAGT.models.Messages.cloneAndSaveAsHistoryById message._id

		me = TAGT.models.Users.findOneById Meteor.userId()

		message.pinned = true
		message.pinnedAt = pinnedAt || Date.now
		message.pinnedBy =
			_id: Meteor.userId()
			username: me.username

		message = TAGT.callbacks.run 'beforeSaveMessage', message

		TAGT.models.Messages.setPinnedByIdAndUserId message._id, message.pinnedBy, message.pinned

		TAGT.models.Messages.createWithTypeRoomIdMessageAndUser 'message_pinned', message.rid, '', me,
			attachments: [
				"text" : message.msg
				"author_name" : message.u.username,
				"author_icon" : getAvatarUrlFromUsername(message.u.username),
				"ts" : message.ts
			]

	unpinMessage: (message) ->
		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'unpinMessage' })

		if not TAGT.settings.get 'Message_AllowPinning'
			throw new Meteor.Error 'error-action-not-allowed', 'Message pinning not allowed', { method: 'unpinMessage', action: 'Message_pinning' }

		room = TAGT.models.Rooms.findOne({ _id: message.rid })

		if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
			return false

		# If we keep history of edits, insert a new message to store history information
		if TAGT.settings.get 'Message_KeepHistory'
			TAGT.models.Messages.cloneAndSaveAsHistoryById message._id

		me = TAGT.models.Users.findOneById Meteor.userId()

		message.pinned = false
		message.pinnedBy =
			_id: Meteor.userId()
			username: me.username

		message = TAGT.callbacks.run 'beforeSaveMessage', message

		TAGT.models.Messages.setPinnedByIdAndUserId message._id, message.pinnedBy, message.pinned


		# Meteor.defer ->
		# 	TAGT.callbacks.run 'afterSaveMessage', TAGT.models.Messages.findOneById(message.id)
