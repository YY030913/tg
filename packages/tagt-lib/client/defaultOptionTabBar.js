TAGT.OptionTabBar.addButton({
	groups: ['channel', 'privategroup'],
	id: 'members-list',
	i18nTitle: 'Members_List',
	icon: 'icon-users',
	template: 'membersList',
	route: {
		name: 'membersList',
		path: '/membersList/:rid',
		action(params/*, queryParams*/) {
			BlazeLayout.render('main', {
			  	center: 'membersListPage'
			});
		},
		link(sub) {
			return {
				rid: sub.rid
			};
		}
	},
	order: 2
});

TAGT.OptionTabBar.addButton({
	groups: ['channel', 'privategroup', 'directmessage'],
	id: 'open-video',
	i18nTitle: 'Initiate_Debate',
	icon: 'mdi-av-videocam',
	template: '',
	action: function(params) {
		if (Session.get('openedRoom')) {
			WebRTC.getInstanceByRoomId(Session.get('openedRoom')).startCall({audio: true, video: true})
		}
	},
	order: 1
});