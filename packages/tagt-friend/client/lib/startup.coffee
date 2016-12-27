###
Meteor.startup ->
	AccountBox.addItem
		name: t('User_Friend'),
		icon: 'icon-users',
		href: 'friend',
		condition: ->
			TAGT.settings.get('User_Friend_Enabled') && TAGT.authz.hasAllPermission('view-user-friend')
###