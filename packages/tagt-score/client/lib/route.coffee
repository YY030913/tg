FlowRouter.route '/user/score',
	name: 'userScore'
	subscriptions: ->
		Meteor.subscribe('userScore')
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'score'
			pageTitle: 'User_Score'
			pageTemplate: 'score'

FlowRouter.route '/user/score/:uid',
	name: 'userScore'
	subscriptions: (params, queryParams) ->
		Meteor.subscribe('userScore', params.uid)
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'score'
			pageTitle: 'User_Score'
			pageTemplate: 'score'