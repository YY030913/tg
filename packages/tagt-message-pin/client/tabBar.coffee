Meteor.startup ->
	Tracker.autorun ->
		if TAGT.settings.get 'Message_AllowPinning'
			TAGT.TabBar.addButton({
				groups: ['channel', 'privategroup', 'directmessage'],
				id: 'pinned-messages',
				i18nTitle: 'Pinned_Messages',
				icon: 'icon-pin',
				template: 'pinnedMessages',
				order: 10
			})

			TAGT.OptionTabBar.addButton({
				groups: ['channel', 'privategroup', 'directmessage'],
				id: 'pinned-messages',
				i18nTitle: 'Pinned_Messages',
				icon: 'icon-pin',
				template: 'pinnedMessages',
				route: {
					name: 'pinnedMessages',
					path: '/pinnedMessages/:rid',
					action: (params) ->
						BlazeLayout.render('main', {
						  	center: 'pinnedMessagesPage'
						});
					,
					link: (sub) ->
						return {
							rid: sub.rid
						};
				},
				order: 10
			})
		else
			TAGT.TabBar.removeButton 'pinned-messages'
			TAGT.OptionTabBar.removeButton 'pinned-messages'
