FlowRouter.route '/user/activity',
	name: 'userActivity'
	subscriptions: ->
		Meteor.subscribe('userActivity')
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'activity'
			pageTitle: 'User_Activity'
			pageTemplate: 'activity'

FlowRouter.route '/user/activity/:uid',
	name: 'userActivity'
	subscriptions: (params, queryParams) ->
		Meteor.subscribe('userActivity', params.uid)
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'activity'
			pageTitle: 'User_Activity'
			pageTemplate: 'activity'