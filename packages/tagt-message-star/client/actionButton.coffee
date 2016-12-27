Meteor.startup ->
	TAGT.MessageAction.addButton
		id: 'star-message'
		icon: 'icon-star-empty'
		i18nLabel: 'Star_Message'
		context: [
			'starred'
			'message'
			'message-mobile'
		]
		action: (event, instance) ->
			message = @_arguments[1]
			message.starred = Meteor.userId()
			Meteor.call 'starMessage', message, (error, result) ->
				if error
					return handleError(error)
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false

			return TAGT.settings.get('Message_AllowStarring') and not message.starred
		order: 10

	TAGT.MessageAction.addButton
		id: 'unstar-message'
		icon: 'icon-star'
		i18nLabel: 'Unstar_Message'
		context: [
			'starred'
			'message'
			'message-mobile'
		]
		action: (event, instance) ->
			message = @_arguments[1]
			message.starred = false
			Meteor.call 'starMessage', message, (error, result) ->
				if error
					return handleError(error)
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false

			return TAGT.settings.get('Message_AllowStarring') and message.starred
		order: 10

	TAGT.MessageAction.addButton
		id: 'jump-to-star-message'
		icon: 'icon-right-hand'
		i18nLabel: 'Jump_to_message'
		context: [
			'starred'
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
		id: 'permalink-star'
		icon: 'icon-link'
		i18nLabel: 'Permalink'
		classes: 'clipboard'
		context: [
			'starred'
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
