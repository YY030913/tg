Template.following.helpers
	isSubsc: ->
		return FlowRouter.subsReady('follow')

	userId: ->
		return FlowRouter.current().params.id || Meteor.userId
		
	

Template.following.onCreated ->
	

Template.following.onRendered ->
	

Template.following.events
