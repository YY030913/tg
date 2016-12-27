Meteor.startup ->
	AccountBox.addItem
		name: 'User_Debate',
		icon: 'icon-comment',
		href: 'user/debates',
		condition: ->
			TAGT.settings.get('User_Debate_Enabled') && TAGT.authz.hasAllPermission('view-user-debates')