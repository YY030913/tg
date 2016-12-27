FlowRouter.route '/debates/:type',
	name: 'typeDebates'

	action: (params) ->
		BlazeLayout.render 'main', 
			pageTitle: 'Discory'
			center: "typeDebates"
			pageTemplate: 'typeDebates'

FlowRouter.route '/debate/confirm/:slug?',
	name: 'debate-confirm'

	subscriptions: (params, queryParams) ->
		@register 'debate', Meteor.subscribe('debate', params.slug)

	action: (params) ->
		BlazeLayout.render 'main', 
			center: "debateCateConfirm"
			pageTemplate: 'debateCateConfirm'

FlowRouter.route '/debate/:slug?',
	name: 'debate'

	subscriptions: (params, queryParams) ->
		@register 'debate', Meteor.subscribe('debate', params.slug)

	action: (params) ->
		BlazeLayout.render 'main', 
			center: "debate"
			pageTemplate: 'debate'

FlowRouter.route '/debate/edit/:slug?',
	name: 'debate-edit'

	subscriptions: (params, queryParams) ->
		@register 'debate', Meteor.subscribe('debate', params.slug)
		@register 'typeSelectTag', Meteor.subscribe('typeSelectTag')

	action: (params) ->
		BlazeLayout.render 'main', 
			center: "debateEdit"
			pageTemplate: 'debateEdit'


FlowRouter.route '/user/debates',
	name: 'userDebates'
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'userDebates'
			pageTitle: 'User_Debate'
			pageTemplate: 'userDebates'

FlowRouter.route '/user/debates/:uid',
	name: 'userDebates'
	action: (params) ->
		BlazeLayout.render 'main',
			center: 'userDebates'
			pageTitle: 'User_Debate'
			pageTemplate: 'userDebates'

FlowRouter.route '/favorite/debates',
	name: 'favorite-debates'
	action: (params) ->
		TAGT.TabBar.showGroup 'favorite-debates'
		BlazeLayout.render 'main',
			center: 'debateFlag'
			pageTitle: t('Favorite_Debates')
			pageTemplate: 'debateFlag'

FlowRouter.route '/admin/debates',
	name: 'admin-debates'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-debates'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Integrations')
			pageTemplate: 'debates'

FlowRouter.route '/admin/debates/new',
	name: 'admin-debates-new'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-debates'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Integration_New')
			pageTemplate: 'debatesNew'

FlowRouter.route '/admin/debates/incoming/:id?',
	name: 'admin-debates-incoming'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-debates'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Integration_Incoming_WebHook')
			pageTemplate: 'debatesIncoming'
			params: params

FlowRouter.route '/admin/debates/outgoing/:id?',
	name: 'admin-debates-outgoing'
	action: (params) ->
		TAGT.TabBar.showGroup 'admin-debates'
		BlazeLayout.render 'main',
			center: 'pageSettingsContainer'
			pageTitle: t('Integration_Outgoing_WebHook')
			pageTemplate: 'debatesOutgoing'
			params: params