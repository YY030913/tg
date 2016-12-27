Meteor.startup ->
	TAGT.ChannelSettings.addOption
		id: 'mail-messages'
		template: 'channelSettingsMailMessages'
		validation: ->
			return TAGT.authz.hasAllPermission('mail-messages')

	TAGT.callbacks.add 'roomExit', (mainNode) ->
		messagesBox = $('.messages-box')
		if messagesBox.get(0)?
			instance = Blaze.getView(messagesBox.get(0))?.templateInstance()
			instance?.resetSelection(false)
	, TAGT.callbacks.priority.MEDIUM, 'room-exit-mail-messages'
