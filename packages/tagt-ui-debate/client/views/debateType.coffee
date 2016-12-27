Template.debateType.helpers
	items: ->
		TAGT.models.Tags.findOpenForUser('o', Meteor.userId())

Template.debateType.onRendered ->

	instance = this


Template.debateType.onCreated ->
	@editor = new ReactiveVar Object
	@name = new ReactiveVar ""
	@save = new ReactiveVar false


Template.debateType.events
	'click input[name="debateType"]': (event, instance)->
		$("#debateType").closeModal()
		$("#debateType").hide()
		Meteor.setTimeout(->
			Session.set "debateType", $(event.target).data().name
		,1000)
		

Template.debateType.onDestroyed ->