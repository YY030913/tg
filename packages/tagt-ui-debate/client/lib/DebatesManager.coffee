@DebatesManager = new class
	defaultLimit = 4

	debates = {}

	getDebates = (tid) ->
		if not debates[tid]?
			debates[tid] =
				hasMore: new ReactiveVar true
				hasMoreNext: new ReactiveVar false
				isLoading: new ReactiveVar false
				unreadNotLoaded: new ReactiveVar 0
				firstUnread: new ReactiveVar
				loaded: 0
		return debates[tid]

	getMore = (tid, limit=defaultLimit) ->
		tag = getDebates tid
		if tag.hasMore.curValue isnt true
			return

		tag.isLoading.set true

		# ScrollListener.setLoader true
		lastDebate = TAGT.models.Debates.findOne({"tags._id": tid}, {sort: {ts: 1}})
		# lastDebate ?= TAGT.models.Debates.findOne({"tags._id": tid}, {sort: {ts: 1}})

		if lastDebate?
			ts = lastDebate.ts
		else
			ts = undefined

		ls = undefined
		typeName = undefined

		subscription = DebateSubscription.findOne "tags._id": tid
		if subscription?
			ls = subscription.ls
			typeName = subscription.t + subscription.name
		else
			curTagDoc = Tag.findOne(_id: tid)
			typeName = curTagDoc?.t + curTagDoc?.name

		Meteor.call 'loadDebates', tid, ts, limit, ls, (err, result) ->
			tag.unreadNotLoaded.set result?.unreadNotLoaded
			tag.firstUnread.set result?.firstUnread

			#if tag.unreadNotLoaded.get() > 0
			#	tag.hasMoreNext.set true

			wrapper = $('.wrapper').get(0)

			if wrapper?
				previousHeight = wrapper.scrollHeight

			for item in result?.debates or [] when item.t isnt 'command'
				#item.roles = _.union(UserRoles.findOne(item.u?._id)?.roles, DebateRoles.findOne({'u._id': item.u?._id})?.roles)
				TAGT.models.Debates.upsert item._id, item

			if wrapper?
				heightDiff = wrapper.scrollHeight - previousHeight
				wrapper.scrollTop += heightDiff

			#Meteor.defer ->
			#	readMessage.refreshUnreadMark(tid, true)
			#	RoomManager.updateMentionsMarksOfRoom typeName

			tag.isLoading.set false
			tag.loaded += result?.debates?.length
			if result?.debates?.length < limit
				tag.hasMore.set false

	getMoreNext = (tid, limit=defaultLimit) ->
		tag = getDebates tid
		if tag.hasMoreNext.curValue isnt true
			return

		instance = Blaze.getView($('.debates-box .wrapper')[0]).templateInstance()
		instance.atBottom = false

		tag.isLoading.set true

		lastDebate = TAGT.models.Debates.findOne({"tags._id": tid}, {sort: {ts: -1}})

		###
		typeName = undefined

		subscription = DebateSubscription.findOne "tags._id": tid
		if subscription?
			ls = subscription.ls
			typeName = subscription.t + subscription.name
		else
			curTagDoc = Tag.findOne(_id: tid)
			typeName = curTagDoc?.t + curTagDoc?.name
		###
		ts = lastDebate.ts

		if ts
			Meteor.call 'loadNextDebates', tid, ts, limit, (err, result) ->
				console.log "loadNextDebates", arguments
				for item in result?.debates or []
					TAGT.models.Debates.upsert item._id, item

				tag.isLoading.set false
				tag.loaded += result.debates.length
				if result.debates.length < limit
					tag.hasMoreNext.set false

	hasMore = (tid) ->
		tag = getDebates tid

		return tag.hasMore.get()

	hasMoreNext = (tid) ->
		tag = getDebates tid
		return tag.hasMoreNext.get()


	getMoreIfIsEmpty = (tid) ->
		tag = getDebates tid

		if tag.loaded is 0
			getMore tid


	isLoading = (tid) ->
		tag = getDebates tid
		return tag.isLoading.get()

	clear = (tid) ->
		TAGT.models.Debates.remove({"tags._id": tid})
		tag = getDebates tid
		if tag?
			tag.hasMore.set true
			tag.isLoading.set false
			tag.loaded = 0

	getDebates: getDebates
	getMore: getMore
	getMoreNext: getMoreNext
	getMoreIfIsEmpty: getMoreIfIsEmpty
	hasMore: hasMore
	hasMoreNext: hasMoreNext
	isLoading: isLoading
	clear: clear
