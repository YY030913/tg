Template.avatarList.helpers
	followed: ->
		return TAGT.models.Follow.find({"friend._id": FlowRouter.current().params.id, "u._id": Meteor.userId()}).count()

Template.avatarList.onCreated ->

Template.avatarList.onRendered ->

Template.avatarList.onDestroyed ->

Template.avatarList.events
