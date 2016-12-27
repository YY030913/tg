FlowRouter.route '/searchs',
	name: 'searchs'

	subscriptions: (params, queryParams) ->

	action: ->
		Tracker.autorun (c) ->
			
			if FlowRouter.subsReady() is true
				BlazeLayout.render 'main', {center: 'stageSearch'}
				c.stop()
			else
				BlazeLayout.render 'main', {center: 'pageLoading'}

FlowRouter.route '/searchs/:type?/:keyword?',
	name: 'searchsResult'

	subscriptions: (params, queryParams) ->

	action: ->
		Tracker.autorun (c) ->
			
			if FlowRouter.subsReady() is true
				BlazeLayout.render 'main', {center: 'stageSearchResult'}
				c.stop()
			else
				BlazeLayout.render 'main', {center: 'pageLoading'}

FlowRouter.route '/search/:type',
	name: 'search'

	action: (params) ->
		Session.set 'search', {type: params.type, name: params.name}
		BlazeLayout.render 'main', {center: "#{params.type}Search"}