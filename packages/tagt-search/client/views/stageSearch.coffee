Template.stageSearch.helpers
	flexOpened: ->
		return 'opened' if TAGT.TabBar.isFlexOpen()
	arrowPosition: ->
		console.log 'room.helpers arrowPosition' if window.rocketDebug
		return 'left' unless TAGT.TabBar.isFlexOpen()

	hotSearch: ->
		TAGT.models.Searchs.find({t: "hot"}).fetch()

	histroySearch: ->
		TAGT.models.Searchs.find({"u._id": Meteor.userId()}).fetch()

	hotReady: ->
		return Template.instance().hotReady.get()

	histroyReady: ->
		return Template.instance().histroyReady.get()

Template.stageSearch.onRendered ->
	console.log "onRendered"

Template.stageSearch.events

	'click .item': (event, instance)->
		instance.searchType.set $(event.target).data("type")
		$(".item").removeClass("active")
		$(event.target).addClass("active")

	'click .isCancel': (e, t) ->
		e.stopPropagation()
		e.preventDefault()
		$("#queryVal").val('')

	'keydown #queryVal': (e, t) ->
		if e.which is 13
			e.stopPropagation()
			e.preventDefault()

			t.filter.set e.currentTarget.value
			FlowRouter.go "searchsResult", type: t.searchType.get(), keyword: t.filter.get()

Template.stageSearch.onCreated ->
	histroySubscription = Meteor.subscribe "searchHistroy"
	hotSubscription = Meteor.subscribe "searchHot"
	instance = @
	@searchType = new ReactiveVar 'debate'
	@filter = new ReactiveVar ''
	@ready = new ReactiveVar true
	@limit = new ReactiveVar 10
	@hotReady = new ReactiveVar false
	@histroyReady = new ReactiveVar false


	@autorun ->
		filter = instance.filter.get()
		limit = instance.limit.get()
		subscription = instance.subscribe 'fullUserData', filter, limit
		instance.ready.set subscription.ready()

		if hotSubscription.ready()
			instance.hotReady.set hotSubscription.ready()
		if histroySubscription.ready()
			instance.histroyReady.set histroySubscription.ready()


	@users = ->
		filter = _.trim instance.filter?.get()
		if filter
			filterReg = new RegExp filter, "i"
			query = { $or: [ { username: filterReg }, { name: filterReg }, { "emails.address": filterReg } ] }
		else
			query = {}

		query.type =
			$in: ['user', 'bot']

		return Meteor.users.find(query, { limit: instance.limit?.get(), sort: { username: 1, name: 1 } }).fetch()