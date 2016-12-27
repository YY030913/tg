Meteor.startup ->
	AccountBox.addItem
		name: 'User_Activity',
		icon: 'icon-activity',
		href: 'user/activity',
		condition: ->
			TAGT.settings.get('User_Activity_Enabled') && TAGT.authz.hasAllPermission('view-user-activity')