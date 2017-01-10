Template.typeDebates.helpers
	fixCordova: (url) ->
		url = "/images/tags/#{url}.png"
		
		if Meteor.isCordova and url?[0] is '/'
			url = Meteor.absoluteUrl().replace(/\/$/, '') + url
			
		return url
		
	fromEmail: ->
		return TAGT.settings.get 'From_Email'

	debatesHistory: ->
		return TAGT.models.Debates.find({t: FlowRouter.getParam('type') || "o"}, { sort: { ts: -1 } })

	unreadData: ->
		return Template.instance().unreadData.get()
	hasMore: ->
		return Template.instance().hasMore.get()
	hasMoreNext: ->
		return Template.instance().hasMoreNext.get()
	isLoading: ->
		return Template.instance().isLoading.get()
	openTags: ->
		return DebateSubscription.find {t:"o", name: $nin: ['Hot', 'News']}
	viewOpenPermission: (name)->
		return "view-open-#{name}"
	unread: (_id)->
		return DebateSubscription.findOne(_id).unread
	debatePath: ->
		return TAGT.tagTypes.getRouteLink @t, @


Template.typeDebates.events
	'click .toggle-search':(e, instance) ->
		FlowRouter.go "searchs"

	'click .load-more': (e, t)-> #click .load-more > button
		t.loadNextMore(FlowRouter.getParam('type') || "o")
		
	'click .new-message': (e) ->
		Template.instance().atTop = true

	'click .fbtn-container': (e, instance) ->
		temp = {
			members: [],
			save: false
		}
		Session.set("debateType", null)
		Meteor.call("createDebate", temp, (error, result)->
			if error?
				if error.error is 'error-invalid-name-length'
					toastr.error TAPi18n.__("error-invalid-name-length", {
						name: temp.name,
						min_length: Settings.findOne("UTF8_Names_MinLength").value, 
						max_length: Settings.findOne("UTF8_Names_MaxLength").value
					})
				else if error.error is 'error-duplicate-channel-name'
					toastr.error TAPi18n.__("error-duplicate-channel-name", {
						channel_name: temp.name
					})
				else if error.error is 'error-duplicate-debate-name'
					toastr.error TAPi18n.__("error-duplicate-debate-name", {
						debate_name: temp.name
					})
				else if error.error is 'error-empty-debate-name'
					toastr.error TAPi18n.__("error-empty-debate-name", {
						name: temp.name
					})
				else if error.error is 'error-rule-not-allowed'
					toastr.error TAPi18n.__("error-create-debate-count-off")

				else if error.error is 'user-not-allow-for-the-debateType'
					toastr.error TAPi18n.__("error-not-allow-for-the-debateType")
					
				else
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
		
	'click .send': (e, t) ->
		e.preventDefault()
		from = $(t.find('[name=from]')).val()
		subject = $(t.find('[name=subject]')).val()
		body = $(t.find('[name=body]')).val()
		dryrun = $(t.find('[name=dryrun]:checked')).val()
		query = $(t.find('[name=query]')).val()

		unless from
			toastr.error TAPi18n.__('error-invalid-from-address')
			return

		if body.indexOf('[unsubscribe]') is -1
			toastr.error TAPi18n.__('error-missing-unsubscribe-link')
			return

		Meteor.call 'Mailer.sendMail', from, subject, body, dryrun, query, (err) ->
			return handleError(err) if err
			toastr.success TAPi18n.__('The_emails_are_being_sent')
			
	'scroll .container': _.throttle (e, instance) ->
		if instance.isLoading.get() is true and instance.hasMoreNext.get() is true or instance.hasMore.get() is true
			if instance.hasMoreNext.get() is true and e.target.scrollTop is 0
				instance.loadMore(FlowRouter.getParam('type') || "o")
			else if instance.hasMore.get() is true and e.target.scrollTop >= e.target.scrollHeight - e.target.clientHeight
				instance.loadNextMore(FlowRouter.getParam('type') || "o")

	, 200

Template.typeDebates.onRendered ->
	instance = @ 

	
	@loadMore = (slug) =>
		if instance.hasMore.get()
			instance.isLoading.set true
			lastDebate = TAGT.models.Debates.findOne({t: slug}, {sort: {ts: -1}})

			if lastDebate?
				end = lastDebate.ts
			else
				end = undefined

			Meteor.call 'loadTypeDebates', slug, end, (error, result)->
				
				if !result?.debates? || result?.debates?.length == 0
					instance.hasMore.set false
				for item in result?.debates or []
					item.t = slug
					TAGT.models.Debates.upsert item._id, item
				instance.isLoading.set false

	@loadNextMore = (slug) =>
		if instance.hasMoreNext.get()
			instance.isLoading.set true
			lastDebate = TAGT.models.Debates.findOne({t: slug}, {sort: {ts: 1}})

			if lastDebate?
				end = lastDebate.ts
			else
				end = undefined

			Meteor.call 'loadNextTypeDebates', slug, end, (error, result)->
				if !result?.debates? || result?.debates?.length == 0
					instance.hasMoreNext.set false
				for item in result?.debates or []
					item.t = slug
					TAGT.models.Debates.upsert item._id, item

				instance.isLoading.set false
		

	@loadMore(FlowRouter.getParam('type') || "o")


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

Template.typeDebates.onCreated ->
	@unreadCount = new ReactiveVar 0

	@hasMore = new ReactiveVar true
	@isLoading = new ReactiveVar true
	@unreadData = new ReactiveVar false
	@hasMoreNext = new ReactiveVar true


	@atTop = true
	instance = @

	Tracker.autorun (c) ->
		console.log "autorun"
		if Meteor.userId()
			console.log Meteor.userId()
			subscription = Meteor.subscribe('debateSubscription')

			if instance.subscriptionsReady() && subscription.ready() && DebateSubscription.find({t:"o", name: $nin: ['Hot', 'News']}).count() > 0
				c.stop()
				
				swiper = new Swiper('.swiper-tag-container', {
					slidesPerView: 4,
					paginationClickable: true
				});


Template.typeDebates.onDestroyed ->
	DebatesManager.clear this.data._id