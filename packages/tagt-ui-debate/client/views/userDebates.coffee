Template.userDebates.helpers
	fromEmail: ->
		return TAGT.settings.get 'From_Email'

	debatesHistory: ->
		if FlowRouter.current().params?.uid?
			return TAGT.models.Debates.find({ "u.id": FlowRouter.current().params.uid}, { sort: { ts: 1 } })
		else	
			return TAGT.models.Debates.find({ "u.id": Meteor.userId()}, { sort: { ts: 1 } })


Template.userDebates.events
	'click .toggle-fullscreen': (e, instance) ->
		window.togglefullscreen()
		
	'click .fbtn-container': (e, instance) ->
		temp = {
			members: [],
			save: false
		}
		Meteor.call("createDebate", temp, (error, result)->
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
		if DebatesManager.isLoading(@_id) is false and (DebatesManager.hasMore(@_id) is true or DebatesManager.hasMoreNext(@_id) is true)
			if DebatesManager.hasMore(@_id) is true and e.target.scrollTop is 0
				DebatesManager.getMore(@_id)
			else if DebatesManager.hasMoreNext(@_id) is true and e.target.scrollTop >= e.target.scrollHeight - e.target.clientHeight
				DebatesManager.getMoreNext(@_id)
	, 200

	'click .load-more > button': ->
		DebatesManager.getMore(@_id)


Template.userDebates.onRendered ->

Template.userDebates.onCreated ->