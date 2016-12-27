Template.debateTag.helpers
	fromEmail: ->
		return TAGT.settings.get 'From_Email'

	debatesHistory: ->
		return TAGT.models.Debates.find({ "tags._id": this._id}, { sort: { ts: -1 } })

	unreadData: ->
		data =
			count: DebatesManager.getDebates(this._id).unreadNotLoaded.get() + Template.instance().unreadCount.get()

		tag = TagManager.getOpenedTagByFid this._id
		if tag?
			data.since = tag.unreadSince?.get()

		return data
	hasMore: ->
		return DebatesManager.hasMore this._id
	isLoading: ->
		return DebatesManager.isLoading this._id


Template.debateTag.events
	'click .toggle-fullscreen': (e, instance) ->
		window.togglefullscreen()

	'click .load-more > button': ->
		DebatesManager.getMore(@_id)
		
	'click .new-message': (e) ->
		console.log "click .new-message"
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
			
	'scroll .wrapper': _.throttle (e, instance) ->
		console.log "DebatesManager.isLoading(@_id)",DebatesManager.isLoading(@_id)
		console.log "DebatesManager.hasMore(@_id)",DebatesManager.hasMore(@_id)
		console.log "DebatesManager.hasMoreNext(@_id)",DebatesManager.hasMoreNext(@_id)
		if DebatesManager.isLoading(@_id) is false and (DebatesManager.hasMore(@_id) is true or DebatesManager.hasMoreNext(@_id) is true)
			console.log "scroll .wrapper"
			if DebatesManager.hasMore(@_id) is true and e.target.scrollTop is 0
				DebatesManager.getMoreNext(@_id)
			else if DebatesManager.hasMoreNext(@_id) is true and e.target.scrollTop >= e.target.scrollHeight - e.target.clientHeight
				DebatesManager.getMore(@_id)
	, 200

	'click .load-more > button': ->
		DebatesManager.getMore(@_id)


Template.debateTag.onRendered ->
	console.log "debateTag.onRendered"

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

Template.debateTag.onCreated ->
	console.log "debateTag.onCreated"
	@unreadCount = new ReactiveVar 0
	@atTop = true

Template.debateTag.onDestroyed ->
	DebatesManager.clear this.data._id