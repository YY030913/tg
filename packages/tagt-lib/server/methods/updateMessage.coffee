Meteor.methods
	updateMessage: (message) ->

		check message, Match.ObjectIncluding({_id:String})

		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'updateMessage' })

		originalMessage = TAGT.models.Messages.findOneById message._id

		if not originalMessage?._id?
			return

		hasPermission = TAGT.authz.hasPermission(Meteor.userId(), 'edit-message', message.rid)
		editAllowed = TAGT.settings.get 'Message_AllowEditing'
		editOwn = originalMessage?.u?._id is Meteor.userId()

		me = TAGT.models.Users.findOneById Meteor.userId()

		unless hasPermission or (editAllowed and editOwn)
			throw new Meteor.Error 'error-action-not-allowed', 'Message editing not allowed', { method: 'updateMessage', action: 'Message_editing' }

		blockEditInMinutes = TAGT.settings.get 'Message_AllowEditing_BlockEditInMinutes'
		if blockEditInMinutes? and blockEditInMinutes isnt 0
			msgTs = moment(originalMessage.ts) if originalMessage.ts?
			currentTsDiff = moment().diff(msgTs, 'minutes') if msgTs?
			if currentTsDiff > blockEditInMinutes
				throw new Meteor.Error 'error-message-editing-blocked', 'Message editing is blocked', { method: 'updateMessage' }

		TAGT.updateMessage(message, Meteor.user());
