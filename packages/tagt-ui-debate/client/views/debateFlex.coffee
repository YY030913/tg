Template.debateFlex.events
	'mouseenter header': ->
		SideNav.overArrow()

	'mouseleave header': ->
		SideNav.leaveArrow()

	'click header': ->
		SideNav.closeFlex()

	'click .cancel-settings': ->
		SideNav.closeFlex()

	'click .debate-link': ->
		menu.close()

Template.debateFlex.helpers
	allowUserProfileChange: ->
		return TAGT.settings.get("Accounts_AllowUserProfileChange")
	allowUserAvatarChange: ->
		return TAGT.settings.get("Accounts_AllowUserAvatarChange")