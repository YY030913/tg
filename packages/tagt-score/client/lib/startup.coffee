Meteor.startup ->
	AccountBox.addItem
		name: t('User_Score'),
		icon: 'icon-graduation-cap',
		href: 'user/score',
		condition: ->
			TAGT.settings.get('User_Score_Enabled') && TAGT.authz.hasAllPermission('view-user-score')