AccountBox.addItem({
	name: 'Livechat',
	icon: 'icon-chat-empty',
	href: 'livechat-current-chats',
	sideNav: 'livechatFlex',
	condition: () => {
		return TAGT.settings.get('Livechat_enabled') && TAGT.authz.hasAllPermission('view-livechat-manager');
	}
});

TAGT.TabBar.addButton({
	groups: ['livechat'],
	id: 'visitor-info',
	i18nTitle: 'Visitor_Info',
	icon: 'icon-info-circled',
	template: 'visitorInfo',
	order: 0
});

// TAGT.TabBar.addButton({
// 	groups: ['livechat'],
// 	id: 'visitor-navigation',
// 	i18nTitle: 'Visitor_Navigation',
// 	icon: 'icon-history',
// 	template: 'visitorNavigation',
// 	order: 10
// });

TAGT.TabBar.addButton({
	groups: ['livechat'],
	id: 'visitor-history',
	i18nTitle: 'Past_Chats',
	icon: 'icon-chat',
	template: 'visitorHistory',
	order: 11
});

TAGT.TabBar.addGroup('message-search', ['livechat']);
TAGT.TabBar.addGroup('starred-messages', ['livechat']);
TAGT.TabBar.addGroup('uploaded-files-list', ['livechat']);
TAGT.TabBar.addGroup('push-notifications', ['livechat']);

TAGT.TabBar.addButton({
	groups: ['livechat'],
	id: 'external-search',
	i18nTitle: 'Knowledge_Base',
	icon: 'icon-lightbulb',
	template: 'externalSearch',
	order: 10
});

TAGT.MessageTypes.registerType({
	id: 'livechat-close',
	system: true,
	message: 'Conversation_closed',
	data(message) {
		return {
			comment: message.msg
		};
	}
});
