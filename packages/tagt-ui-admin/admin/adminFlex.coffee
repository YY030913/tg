Template.adminFlex.onCreated ->
	if not TAGT.settings.cachedCollectionPrivate?
		TAGT.settings.cachedCollectionPrivate = new TAGT.CachedCollection({ name: 'private-settings', eventType: 'onAll' })
		TAGT.settings.collectionPrivate = TAGT.settings.cachedCollectionPrivate.collection
		TAGT.settings.cachedCollectionPrivate.init()


Template.adminFlex.helpers
	groups: ->
		return TAGT.settings.collectionPrivate.find({type: 'group'}, { sort: { sort: 1, i18nLabel: 1 } }).fetch()
	label: ->
		return TAPi18n.__(@i18nLabel or @_id)
	adminBoxOptions: ->
		return TAGT.AdminBox.getOptions()


Template.adminFlex.events
	'mouseenter header': ->
		SideNav.overArrow()

	'mouseleave header': ->
		SideNav.leaveArrow()

	'click header': ->
		SideNav.closeFlex()

	'click .cancel-settings': ->
		SideNav.closeFlex()

	'click .admin-link': ->
		menu.close()
