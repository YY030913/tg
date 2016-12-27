Blaze.registerHelper 'pathFor', (path, kw) ->
	return FlowRouter.path path, kw.hash

BlazeLayout.setRoot 'body'

Blaze._allowJavascriptUrls()

FlowRouter.subscriptions = ->
	Tracker.autorun =>
		if Meteor.userId()
			@register 'userData', Meteor.subscribe('userData')
			@register 'activeUsers', Meteor.subscribe('activeUsers')

			TagManager.init()
			@register 'ads', Meteor.subscribe('ads')
			@register 'friendSubscriptionData', Meteor.subscribe('friendSubscriptionData')


FlowRouter.route '/',
	name: 'index'

	action: ->
		BlazeLayout.render 'main', { modal: TAGT.Layout.isEmbedded(), center: 'loading' }
		if not Meteor.userId()
			return FlowRouter.go 'home'

		Tracker.autorun (c) ->
			if FlowRouter.subsReady() is true
				Meteor.defer ->
					if Meteor.user().defaultRoom?
						room = Meteor.user().defaultRoom.split('/')
						FlowRouter.go room[0], {name: room[1]}
					else
						FlowRouter.go 'home'
				c.stop()


FlowRouter.route '/login',
	name: 'login'

	action: ->
		FlowRouter.go 'home'


FlowRouter.route '/home',
	name: 'home'

	action: ->
		BlazeLayout.render 'main', 
			pageTitle: 'Discory'
			center: "typeDebates"
			pageTemplate: 'typeDebates'


FlowRouter.route '/changeavatar',
	name: 'changeAvatar'

	action: ->
		TAGT.TabBar.showGroup 'changeavatar'
		BlazeLayout.render 'main', {center: 'avatarPrompt'}


FlowRouter.route '/account/:group?',
	name: 'account'

	subscriptions: (params, queryParams) ->
		@register 'follow', Meteor.subscribe('follow',  Meteor.userId())

	action: (params) ->
		unless params.group
			params.group = 'Setting'
		params.group = _.capitalize params.group, true
		#TAGT.TabBar.showGroup 'account'
		BlazeLayout.render 'main', { center: "account#{params.group}" }


FlowRouter.route '/history/private',
	name: 'privateHistory'

	subscriptions: (params, queryParams) ->
		@register 'privateHistory', Meteor.subscribe('privateHistory')

	action: ->
		Session.setDefault('historyFilter', '')
		TAGT.TabBar.showGroup 'private-history'
		BlazeLayout.render 'main', {center: 'privateHistory'}


FlowRouter.route '/terms-of-service',
	name: 'terms-of-service'

	action: ->
		Session.set 'cmsPage', 'Layout_Terms_of_Service'
		BlazeLayout.render 'cmsPage'

FlowRouter.route '/privacy-policy',
	name: 'privacy-policy'

	action: ->
		Session.set 'cmsPage', 'Layout_Privacy_Policy'
		BlazeLayout.render 'cmsPage'

FlowRouter.route '/room-not-found/:type/:name',
	name: 'room-not-found'

	action: (params) ->
		Session.set 'roomNotFound', {type: params.type, name: params.name}
		BlazeLayout.render 'main', {center: 'roomNotFound'}

FlowRouter.route '/fxos',
	name: 'firefox-os-install'

	action: ->
		BlazeLayout.render 'fxOsInstallPrompt'

FlowRouter.route '/register/:hash',
	name: 'register-secret-url'
	action: (params) ->
		BlazeLayout.render 'secretURL'

		# if TAGT.settings.get('Accounts_RegistrationForm') is 'Secret URL'
		# 	Meteor.call 'checkRegistrationSecretURL', params.hash, (err, success) ->
		# 		if success
		# 			Session.set 'loginDefaultState', 'register'
		# 			BlazeLayout.render 'main', {center: 'home'}
		# 			KonchatNotification.getDesktopPermission()
		# 		else
		# 			BlazeLayout.render 'logoLayout', { render: 'invalidSecretURL' }
		# else
		# 	BlazeLayout.render 'logoLayout', { render: 'invalidSecretURL' }


FlowRouter.route '/messages',
	name: 'messages'

	action: ->
		Tracker.autorun (c) ->
			console.log "meessages"
			if FlowRouter.subsReady() is true
				console.log "ready"
				BlazeLayout.render 'main', {center: 'messageList'}
				c.stop()
			else
				BlazeLayout.render 'main', {center: 'pageLoading'}