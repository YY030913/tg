Template.sideNav.helpers
	flexTemplate: ->
		return SideNav.getFlex().template

	flexData: ->
		return SideNav.getFlex().data

	footer: ->
		return TAGT.settings.get 'Layout_Sidenav_Footer'

	showStarredRooms: ->
		favoritesEnabled = TAGT.settings.get 'Favorite_Rooms'
		hasFavoriteRoomOpened = ChatSubscription.findOne({ f: true, open: true })

		return true if favoritesEnabled and hasFavoriteRoomOpened

	roomType: ->
		return TAGT.roomTypes.getTypes()

	canShowRoomType: ->
		userPref = Meteor.user()?.settings?.preferences?.mergeChannels
		globalPref = TAGT.settings.get('UI_Merge_Channels_Groups')
		mergeChannels = if userPref? then userPref else globalPref
		if mergeChannels
			return TAGT.roomTypes.checkCondition(@) and @template isnt 'privateGroups'
		else
			return TAGT.roomTypes.checkCondition(@)

	templateName: ->
		userPref = Meteor.user()?.settings?.preferences?.mergeChannels
		globalPref = TAGT.settings.get('UI_Merge_Channels_Groups')
		mergeChannels = if userPref? then userPref else globalPref
		if mergeChannels
			return if @template is 'channels' then 'combined' else @template
		else
			return @template

	alert: (_id)->
		return DebateSubscription.findOne(_id).alert

	unread: (_id)->
		return DebateSubscription.findOne(_id).unread

	subReady: (sub)->
		return FlowRouter.subsReady(sub);
		
	userId: ->
		return Meteor.userId();

	active: (nav)->
		if Session.get('navMenu') is nav
			return 'active'

	hasNewFriend: ->
		return friendSubscripion.findOne({"u._id": Meteor.userId()})?.unread > 0
	newFriendCount: ->
		return friendSubscripion.findOne({"u._id": Meteor.userId()})?.unread

	debatePath: ->
		return TAGT.tagTypes.getRouteLink @t, @

	showAdminOption: ->
		return TAGT.authz.hasAtLeastOnePermission( ['view-statistics', 'view-room-administration', 'view-user-administration', 'view-privileged-setting' ]) or TAGT.AdminBox.getOptions().length > 0

	registeredMenus: ->
		return AccountBox.getItems()

	viewOpenPermission: (name)->
		return "view-open-#{name}"

	viewPrivatePermission: (name)->
		return "view-private-#{name}"

Template.sideNav.events
	'click .close-flex': ->
		SideNav.closeFlex()

	'click .arrow': ->
		SideNav.toggleCurrent()

	'mouseenter .header': ->
		SideNav.overArrow()

	'mouseleave .header': ->
		SideNav.leaveArrow()

	'scroll .rooms-list': ->
		menu.updateUnreadBars()

	'dropped .side-nav': (e) ->
		e.preventDefault()

	'click .debatePreferences': ->
		Session.set('navMenu','debatePreferences')

	'click #account': (event) ->
		FlowRouter.go 'account'

	'click #admin': ->
		SideNav.setFlex "adminFlex"
		SideNav.openFlex()
		FlowRouter.go 'admin-info'

	'click #logout': (event) ->
		event.preventDefault()
		user = Meteor.user()
		FlowRouter.go '/debates/o'
		Meteor.logout ->
			TAGT.callbacks.run 'afterLogoutCleanUp', user
			Meteor.call 'logoutCleanUp', user, (err) ->
				if err?
					toastr.error t 'User_not_found_or_incorrect_password'

			
	'click .side-menu': ->
		menu.close()
		
Template.sideNav.onRendered ->
	SideNav.init()
	menu.init()

	Meteor.defer ->
		menu.updateUnreadBars()