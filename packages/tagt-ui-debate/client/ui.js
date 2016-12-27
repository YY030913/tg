Meteor.startup( function() {
	AccountBox.addItem({
		name: 'userDebates',
		icon: 'icon-comment',
		href: 'user/debates',
		condition: () => {
			return TAGT.settings.get('User_Debate_Enabled') && TAGT.authz.hasAllPermission('view-user-debates');
		}
	});
})