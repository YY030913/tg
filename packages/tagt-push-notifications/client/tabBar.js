Meteor.startup(function() {
	TAGT.TabBar.addButton({
		groups: ['channel', 'privategroup', 'directmessage'],
		id: 'push-notifications',
		i18nTitle: 'Notifications',
		icon: 'icon-bell-alt',
		template: 'pushNotificationsFlexTab',
		order: 2
	});
});
