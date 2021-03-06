Meteor.startup ->
	TAGT.MessageAction.addButton
		id: 'pin-message'
		icon: 'icon-pin'
		i18nLabel: 'Pin_Message'
		context: [
			'pinned'
			'message'
			'message-mobile'
		]
		action: (event, instance) ->
			message = @_arguments[1]
			message.pinned = true
			Meteor.call 'pinMessage', message, (error, result) ->
				if error
					return handleError(error)
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false
			else if message.pinned or not TAGT.settings.get('Message_AllowPinning')
				return false

			return TAGT.authz.hasAtLeastOnePermission 'pin-message', message.rid
		order: 20

	TAGT.MessageAction.addButton
		id: 'unpin-message'
		icon: 'icon-pin rotate-45'
		i18nLabel: 'Unpin_Message'
		context: [
			'pinned'
			'message'
			'message-mobile'
		]
		action: (event, instance) ->
			message = @_arguments[1]
			message.pinned = false
			Meteor.call 'unpinMessage', message, (error, result) ->
				if error
					return handleError(error)
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false
			else if not message.pinned or not TAGT.settings.get('Message_AllowPinning')
				return false

			return TAGT.authz.hasAtLeastOnePermission 'pin-message', message.rid
		order: 21

	TAGT.MessageAction.addButton
		id: 'jump-to-pin-message'
		icon: 'icon-right-hand'
		i18nLabel: 'Jump_to_message'
		context: [
			'pinned'
		]
		action: (event, instance) ->
			message = @_arguments[1]
			TAGT.MessageAction.hideDropDown()
			RoomHistoryManager.getSurroundingMessages(message, 50)
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false
				
			return true
		order: 100

	TAGT.MessageAction.addButton
		id: 'permalink-pinned'
		icon: 'icon-link'
		i18nLabel: 'Permalink'
		classes: 'clipboard'
		context: [
			'pinned'
		]
		action: (event, instance) ->
			message = @_arguments[1]
			TAGT.MessageAction.hideDropDown()
			$(event.currentTarget).attr('data-clipboard-text', TAGT.MessageAction.getPermaLink(message._id));
			toastr.success(TAPi18n.__('Copied'))
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false
				
			return true
		order: 101
