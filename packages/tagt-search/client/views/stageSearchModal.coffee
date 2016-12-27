
Template.stageSearchModal.helpers
	flexOpened: ->
		return 'opened' if TAGT.TabBar.isFlexOpen()
	arrowPosition: ->
		console.log 'room.helpers arrowPosition' if window.rocketDebug
		return 'left' unless TAGT.TabBar.isFlexOpen()

Template.stageSearchModal.onRendered ->
	Tracker.afterFlush ->
		###
		SideNav.setFlex "accountFlex"
		SideNav.openFlex()
		###
