Template.stageSearchResult.helpers

	users: ->
		console.log SearchUsersResult.find().fetch()
		SearchUsersResult.find().fetch()

	debatesHistory: ->
		SearchDebatesResult.find().fetch()

	debateType: ->
		console.log Template.instance().type.get() == "debate"
		return Template.instance().type.get() == "debate"

	userType: ->
		console.log Template.instance().type.get()
		console.log Template.instance().type.get() == "users"
		return Template.instance().type.get() == "users"


Template.stageSearchResult.onRendered ->
	Tracker.afterFlush ->
		###
		SideNav.setFlex "accountFlex"
		SideNav.openFlex()
		###

Template.stageSearchResult.events

	'click .item': (event, instance)->
		instance.type.set $(event.target).data("type")
		$(".item").removeClass("active")
		$(event.target).addClass("active")

	'click .isCancel': (e, t) ->
		e.stopPropagation()
		e.preventDefault()
		$("#queryVal").val('')

	'scroll .wrapper': _.throttle (e, t) ->
		console.log "e.target.scrollTop",e.target.scrollTop
		console.log "e.target.scrollHeight",e.target.scrollHeight
		console.log "e.target.clientHeight",e.target.clientHeight

		if t.isLoading is false and t.hasMore is true
			if e.target.scrollTop >= e.target.scrollHeight - e.target.clientHeight
				t.getMore()
	, 200

	'keydown #queryVal': (e, t) ->
		if e.which is 13
			e.stopPropagation()
			e.preventDefault()

			t.keyword.set e.currentTarget.value
			SearchUsersResult.remove({})
			SearchDebatesResult.remove({})

			t.getMore()

	'click .load-more > button': (e, t)->
		t.getMore()

Template.stageSearchResult.onCreated ->

	@type = new ReactiveVar ''
	@keyword = new ReactiveVar ''
	@isLoading = false
	@hasMore = true

	@type.set FlowRouter.current().params.type
	@keyword.set FlowRouter.current().params.keyword

	@getMoreDebates = =>
		last = SearchDebatesResult.findOne({}, {sort: {ts: 1}})
		if last?
			ts = last.ts
		else
			ts = undefined
		console.log "call searchDebates"
		Meteor.call "searchDebates", @keyword.get(), ts, (error, result) ->
			console.log error,result
			if error?
				console.log error
			else
				for item in result?.debates or []
					SearchDebatesResult.upsert {_id: item._id}, item

	@getMoreUsers = =>
		last = SearchUsersResult.findOne({}, {sort: {ts: 1}})
		if last?
			ts = last.ts
		else
			ts = undefined
		console.log "call searchUsers"
		Meteor.call "searchUsers", @keyword.get(), (error, result) ->
			console.log error,result
			if error?
				console.log error
			else
				for item in result?.users or []
					SearchUsersResult.upsert {_id: item._id}, item

	@getMore = =>
		if @type.get() == 'debate'
			@getMoreDebates()
			
		if @type.get() == 'users'
			@getMoreUsers()

	@getMore()

