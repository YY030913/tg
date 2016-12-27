FlowRouter.route '/friend',
	name: 'friend'
	subscriptions: (params, queryParams) ->
		@register 'follow', Meteor.subscribe('follow',  Meteor.userId())
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'friend'
			pageTitle: t('Friend')
			pageTemplate: 'friend'


FlowRouter.route '/user/following/:id',
	name: 'userFollowing'
	subscriptions: (params, queryParams) ->
		@register 'follow', Meteor.subscribe('follow',  params.id)
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'following'
			pageTitle: t('Following')
			pageTemplate: 'following'

FlowRouter.route '/user/follower/:id',
	name: 'userFollower'
	subscriptions: (params, queryParams) ->
		@register 'follow', Meteor.subscribe('follow',  params.id)
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'follower'
			pageTitle: t('Follower')
			pageTemplate: 'follower'