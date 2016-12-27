Template.userList.helpers
	followed: ->
		return TAGT.models.Follow.find({"friend._id": FlowRouter.current().params.id, "u._id": Meteor.userId()}).count()

Template.userList.onCreated ->

Template.userList.onRendered ->

Template.userList.onDestroyed ->

Template.userList.events
