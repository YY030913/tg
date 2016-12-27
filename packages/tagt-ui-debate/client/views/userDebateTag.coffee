Template.userDebateTag.helpers
	debatesHistory: ->
		return TAGT.models.Debates.find({ "u._id": @userId}, { sort: { ts: -1 } })

	unreadData: ->
		return Template.instance().unreadData.get()
	hasMore: ->
		return Template.instance().hasMore.get()
	hasMoreNext: ->
		return Template.instance().hasMoreNext.get()
	isLoading: ->
		return Template.instance().isLoading.get()

Template.userDebateTag.events
			
	'scroll .wrapper': _.throttle (e, instance) ->
		if instance.isLoading.get() is true and instance.hasMoreNext.get() is true or instance.hasMore.get() is true
			if instance.hasMoreNext.get() is true and e.target.scrollTop is 0
				instance.loadMore()
			else if instance.hasMore.get() is true and e.target.scrollTop >= e.target.scrollHeight - e.target.clientHeight
				instance.loadNextMore()

	, 200

	'click .load-more': (e, t)-> #click .load-more > button
		t.loadNextMore()
		
	'click .new-message': (e) ->
		Template.instance().atTop = true


Template.userDebateTag.onRendered ->

	console.log "userDebateTag.onRendered"

	template = this

	wrapper = this.find('.wrapper')


	newMessage = this.find(".new-message")

	template.isAtTop = ->
		if wrapper.scrollHeight == 0#wrapper.scrollTop >= wrapper.scrollHeight - wrapper.clientHeight
			newMessage.className = "new-message not"
			return true
		return false

	template.checkIfScrollIsAtTop = ->
		template.atTop = template.isAtTop()
		readMessage.enable()
		readMessage.read()

	wrapper.addEventListener 'mousewheel', ->
		console.log "wrapper.scrollHeight",wrapper.scrollHeight
		console.log "wrapper.scrollTop ",wrapper.scrollTop 
		console.log "wrapper.clientHeight",wrapper.clientHeight
		template.atTop = false
		Meteor.defer ->
			template.checkIfScrollIsAtTop()

	wrapper.addEventListener 'wheel', ->
		template.atTop = false
		Meteor.defer ->
			template.checkIfScrollIsAtTop()

	wrapper.addEventListener 'touchstart', ->
		template.atTop = false

	wrapper.addEventListener 'touchend', ->
		Meteor.defer ->
			template.checkIfScrollIsAtTop()
		Meteor.setTimeout ->
			template.checkIfScrollIsAtTop()
		, 1000
		Meteor.setTimeout ->
			template.checkIfScrollIsAtTop()
		, 2000

Template.userDebateTag.onCreated ->
	@unreadCount = new ReactiveVar 0

	@hasMore = new ReactiveVar true
	@isLoading = new ReactiveVar true
	@unreadData = new ReactiveVar false
	@hasMoreNext = new ReactiveVar true


	@atTop = true

	instance = this

	@loadMore = () =>
		if instance.hasMore.get()
			instance.isLoading.set true
			lastDebate = TAGT.models.Debates.findOne({"u._id": instance.data.userId}, {sort: {ts: -1}})

			if lastDebate?
				end = lastDebate.ts
			else
				end = undefined

			Meteor.call 'loadUserDebates', instance.data.userId, end, (error, result)->
				console.log result
				if !result?.debates? || result?.debates?.length == 0
					instance.hasMore.set false
				for item in result?.debates or []
					TAGT.models.Debates.upsert item._id, item
				instance.isLoading.set false

	@loadNextMore = () =>
		if instance.hasMoreNext.get()
			instance.isLoading.set true
			lastDebate = TAGT.models.Debates.findOne({"u._id": instance.data.userId}, {sort: {ts: 1}})

			if lastDebate?
				end = lastDebate.ts
			else
				end = undefined

			Meteor.call 'loadNextUserDebates', instance.data.userId, end, (error, result)->
				if !result?.debates? || result?.debates?.length == 0
					instance.hasMoreNext.set false
				for item in result?.debates or []
					TAGT.models.Debates.upsert item._id, item

				instance.isLoading.set false

	@loadMore()

Template.userDebateTag.onDestroyed ->
	DebatesManager.clear this.data._id