Template.messageList.helpers
	rooms: ->
		query =
			t: { $in: ['c', 'd', 'p']},
			open: true

		if Meteor.user()?.settings?.preferences?.unreadRoomsMode
			query.alert =
				$ne: true
		return ChatSubscription.find query, { sort: 't': 1, 'name': 1 }

	route: ->
		return TAGT.roomTypes.getRouteLink @t, @

	createTime: (ts) ->

		if moment().diff(moment(ts), 'days') >= 1
			return moment(ts).locale(TAPi18n.getLanguage()).format('YYYY-MM-DD')
		else
			return moment(ts).locale(TAPi18n.getLanguage()).fromNow();

	getUsers: (rid)->
		if ChatSubscription.findOne({rid: rid})?.t is "d"
			return ChatSubscription.findOne({rid: rid}).name
		else
			console.log TAGT.models.Rooms.findOne(rid)?.usernames
			return TAGT.models.Rooms.findOne(rid)?.usernames

	subReady: ->
		return Template.instance().subReady.get()

Template.messageList.onRendered ->
	roomSubscription = Meteor.subscribe "rooms"
	self = this
	Tracker.autorun ->
		if roomSubscription.ready()
			console.log "ready"
			self.subReady.set(roomSubscription.ready())



Template.messageList.onCreated ->
	@subReady = new ReactiveVar false