Meteor.startup ->
	TAGT.TabBar.addButton
		groups: ['channel', 'privategroup', 'directmessage']
		id: 'channel-settings'
		i18nTitle: 'Room_Info'
		icon: 'icon-info-circled'
		template: 'channelSettings'
		order: 0

	TAGT.OptionTabBar.addButton
		groups: ['channel', 'privategroup', 'directmessage']
		id: 'channel-settings'
		i18nTitle: 'Room_Info'
		icon: 'icon-info-circled'
		template: 'channelSettings'
		route: {
			name: 'channelSettings',
			path: '/channelSettings/:rid',
			action: (params) ->
				BlazeLayout.render('main', {
				  	center: 'channelSettingsPage'
				});
			link: (sub) ->
				return {
					rid: sub.rid
				};
		},
		order: 0