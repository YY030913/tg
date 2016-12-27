FlowRouter.route '/user/profile/:id?',
	name: 'user-profile'
	subscriptions: (params, queryParams) ->
		@register 'follow', Meteor.subscribe('follow',  params.id)
		@register 'userProfile', Meteor.subscribe('userProfile',  params.id)
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'userProfile'
			pageTitle: 'User_Profile'
			pageTemplate: 'userProfile'