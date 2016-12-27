Template.debates.helpers
	languages: ->
		languages = TAPi18n.getLanguages()
		result = []
		for key, language of languages
			result.push _.extend(language, { key: key })
		return _.sortBy(result, 'key')

	userLanguage: (key) ->
		return (Meteor.user().language or defaultUserLanguage())?.split('-').shift().toLowerCase() is key

	asMore: ->
		return DebatesManager.hasMore Template.instance._id

	hasMoreNext: ->
		return DebatesManager.hasMoreNext Template.instance._id

	isLoading: ->
		return DebatesManager.isLoading Template.instance._id

	debatesHistory: ->
		return TAGT.models.Debates.find({ "tags._id": Template.instance()._id.get()}, { sort: { ts: -1 } })

Template.debates.onCreated ->
	@result = "";
	@_id = new ReactiveVar 0;
	@slideindex = new ReactiveVar 0;
	@tag = new ReactiveVar "";
	@unreadCount = new ReactiveVar 0

Template.debates.events
	'click .fbtn-container': (e, instance) ->
		Meteor.call("createDebate", null, null, null, new Array, false, (error, result)->
			
			if error?
				toastr.error t(error.message)
			else 
				if result?
					$('body').addClass('mode-expand');
					instance.result = result
					createtimeout = Meteor.setTimeout -> 
						$('body').removeClass('mode-expand');
						Meteor.clearTimeout createtimeout
						FlowRouter.go "debate-edit", 
							slug: instance.result

					,500
				else
					toastr.error t("Debate_Create_Failed");
		);
	'scroll .panes': _.throttle (e, instance) ->
		console.log instance._id.get()
		console.log DebatesManager.hasMore(instance._id.get()) is true
		console.log DebatesManager.isLoading(instance._id.get()) is false
		console.log DebatesManager.hasMoreNext(instance._id.get()) is true
		if DebatesManager.isLoading(instance._id.get()) is false and (DebatesManager.hasMore(instance._id.get()) is true or DebatesManager.hasMoreNext(instance._id.get()) is true)
			console.log e.target.scrollTop
			if DebatesManager.hasMore(instance._id.get()) is true and e.target.scrollTop is 0
				console.log "load more"
				DebatesManager.getMore(instance._id.get())
				
			else if DebatesManager.hasMoreNext(instance._id.get()) is true and e.target.scrollTop >= e.target.scrollHeight - e.target.clientHeight
				console.log "load more next"
				DebatesManager.getMoreNext(instance._id.get())
				
	, 200
			

Template.debates.onRendered ->
	instance = this
	$(".pane").height($("body").height() - $(".fixed-title").height() - $(".nav").height() - $(".bar").height())
	window.onresize = ->
		console.log $(".pane").width()
		$(".pane").height($("body").height() - $(".fixed-title").height() - $(".nav").height() - $(".bar").height())
	slideTab = new SlideTab('.panes', {
		initialPane: 0,
		slideChanged: (index) ->
			$('.bar-progress').css('left', 50 * index + '%');
			instance.slideindex.set(index);
			if index == 0
					
				currentTracker0 = Meteor.setInterval ->
					TagManager.open("ohot")
					if !TagManager.open("ohot").ready()
						return
					Meteor.clearInterval currentTracker0
					instance.tag.set("ohot");
					instance._id.set(TagManager.openedTags.ohot.tid)
			else if index == 1

				currentTracker0 = Meteor.setInterval ->
					TagManager.open("onews")
					if !TagManager.open("onews").ready()
						return
					Meteor.clearInterval currentTracker0
					instance.tag.set("onews");
					instance._id.set(TagManager.openedTags.onews.tid)
	});

	instance = this

	pages = [0, 0, 0, 0];

	slideTab.dropload = null
			

	$('.nav').on 'click', '.nav-tab', ->
		index = $('.nav-tab').index(this);
		console.log("slideTo");
		slideTab.slideTo(index);
		$('.bar-progress').css('left', 50 * index + '%');
		instance.slideindex.set(index);
		if index == 0
				
			currentTracker0 = Meteor.setInterval ->
				TagManager.open("ohot")
				if !TagManager.open("ohot").ready()
					return
				Meteor.clearInterval currentTracker0
				instance.tag.set("ohot");
				instance._id.set(TagManager.openedTags.ohot.tid)
		else if index == 1

			currentTracker0 = Meteor.setInterval ->
				TagManager.open("onews")
				if !TagManager.open("onews").ready()
					return
				Meteor.clearInterval currentTracker0
				instance.tag.set("onews");
				instance._id.set(TagManager.openedTags.onews.tid)

	containerBars = $('.debate-list > .container-bars')
	containerBarsOffset = containerBars.offset()

	updateUnreadCount = _.throttle ->
	
		firstMessageOnScreen = document.elementFromPoint(containerBarsOffset.left+1, containerBarsOffset.top+containerBars.height()+1)
		if firstMessageOnScreen?.id?
			firstMessage = Debates.findOne firstMessageOnScreen.id
			if firstMessage?
				subscription = DebateSubscription.findOne rid: template.data._id
				count = Debates.find({rid: template.data._id, ts: {$lt: firstMessage.ts, $gt: subscription?.ls}}).count()
				template.unreadCount.set count
			else
				template.unreadCount.set 0
	, 300

	wrapper.addEventListener 'scroll', ->
		updateUnreadCount()

Template.debates.onDestroyed ->