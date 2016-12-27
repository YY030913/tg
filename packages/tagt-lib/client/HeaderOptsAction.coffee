TAGT.HeaderOptsAction = new class
	buttons = new ReactiveVar {}

	###
	config expects the following keys (only id is mandatory):
		id (mandatory)
		icon: string
		i18nLabel: string
		action: function(event, instance)
		validation: function(message)
		order: integer
	###
	addButton = (config) ->
		unless config?.id
			return false

		if config.route?.path? and config.route?.name? and config.route?.action?
			FlowRouter.route config.route.path,
				name: config.route.name
				action: config.route.action
				triggersExit: [roomExit]

		Tracker.nonreactive ->
			btns = buttons.get()
			btns[config.id] = config
			buttons.set btns

	removeButton = (id) ->
		Tracker.nonreactive ->
			btns = buttons.get()
			delete btns[id]
			buttons.set btns

	updateButton = (id, config) ->
		Tracker.nonreactive ->
			btns = buttons.get()
			if btns[id]
				btns[id] = _.extend btns[id], config
				buttons.set btns

	getButtonById = (id) ->
		allButtons = buttons.get()
		return allButtons[id]

	getButtons = (message, context) ->
		allButtons = _.toArray buttons.get()
		if message
			allowedButtons = _.compact _.map allButtons, (button) ->
				if not button.context? or button.context.indexOf(context) > -1
					if not button.validation? or button.validation(message, context)
						return button
		else
			allowedButtons = allButtons

		return _.sortBy allowedButtons, 'order'

	resetButtons = ->
		buttons.set {}

	getRouteLink = (id, subData) ->
		allButtons = buttons.get()
		return FlowRouter.path allButtons[id].route.name, allButtons[id].route.link(subData)

	addButton: addButton
	removeButton: removeButton
	updateButton: updateButton
	getButtons: getButtons
	getButtonById: getButtonById
	resetButtons: resetButtons
	getRouteLink: getRouteLink

Meteor.startup ->

	$(document).click (event) =>
		if !$(event.target).closest('.header-opts').length and !$(event.target).is('.header-opts')
			$('.header-opts-dropdown:visible').hide()




	TAGT.HeaderOptsAction.addButton
		id: 'edit-message'
		icon: 'icon-pencil'
		i18nLabel: 'Edit'
		context: [
			'message'
			'message-mobile'
		]
		route: {
			name: 'membersList',
			path: '/membersList/:rid',
			action: (params) ->
				BlazeLayout.render('main', {
				  	center: 'membersListPage'
				});
			link: (sub) ->
				rid: sub.rid
		},
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false

			hasPermission = TAGT.authz.hasAtLeastOnePermission('edit-message', message.rid)
			isEditAllowed = TAGT.settings.get 'Message_AllowEditing'
			editOwn = message.u?._id is Meteor.userId()

			return unless hasPermission or (isEditAllowed and editOwn)

			blockEditInMinutes = TAGT.settings.get 'Message_AllowEditing_BlockEditInMinutes'
			if blockEditInMinutes? and blockEditInMinutes isnt 0
				msgTs = moment(message.ts) if message.ts?
				currentTsDiff = moment().diff(msgTs, 'minutes') if msgTs?
				return currentTsDiff < blockEditInMinutes
			else
				return true
		order: 1

	TAGT.HeaderOptsAction.addButton
		id: 'delete-message'
		icon: 'icon-trash-alt'
		i18nLabel: 'Delete'
		context: [
			'message'
			'message-mobile'
		]
		route: {
			name: 'membersList',
			path: '/membersList/:rid',
			action: (params) ->
				BlazeLayout.render('main', {
				  	center: 'membersListPage'
				});
			link: (sub) ->
				rid: sub.rid
		},
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false

			hasPermission = TAGT.authz.hasAtLeastOnePermission('delete-message', message.rid)
			isDeleteAllowed = TAGT.settings.get 'Message_AllowDeleting'
			deleteOwn = message.u?._id is Meteor.userId()

			return unless hasPermission or (isDeleteAllowed and deleteOwn)

			blockDeleteInMinutes = TAGT.settings.get 'Message_AllowDeleting_BlockDeleteInMinutes'
			if blockDeleteInMinutes? and blockDeleteInMinutes isnt 0
				msgTs = moment(message.ts) if message.ts?
				currentTsDiff = moment().diff(msgTs, 'minutes') if msgTs?
				return currentTsDiff < blockDeleteInMinutes
			else
				return true
		order: 2

	TAGT.HeaderOptsAction.addButton
		id: 'permalink'
		icon: 'icon-link'
		i18nLabel: 'Permalink'
		classes: 'clipboard'
		context: [
			'message'
			'message-mobile'
		]
		route: {
			name: 'membersList',
			path: '/membersList/:rid',
			action: (params) ->
				BlazeLayout.render('main', {
				  	center: 'membersListPage'
				});
			link: (sub) ->
				rid: sub.rid
		},
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false
			
			return true
		order: 3

	TAGT.HeaderOptsAction.addButton
		id: 'copy'
		icon: 'icon-paste'
		i18nLabel: 'Copy'
		classes: 'clipboard'
		context: [
			'message'
			'message-mobile'
		]
		route: {
			name: 'membersList',
			path: '/membersList/:rid',
			action: (params) ->
				BlazeLayout.render('main', {
				  	center: 'membersListPage'
				});
			link: (sub) ->
				rid: sub.rid
		},
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false
				
			return true
		order: 4

	TAGT.HeaderOptsAction.addButton
		id: 'quote-message'
		icon: 'icon-quote-left'
		i18nLabel: 'Quote'
		context: [
			'message'
			'message-mobile'
		]
		route: {
			name: 'membersList',
			path: '/membersList/:rid',
			action: (params) ->
				BlazeLayout.render('main', {
				  	center: 'membersListPage'
				});
			link: (sub) ->
				rid: sub.rid
		},
		validation: (message) ->
			room = TAGT.models.Rooms.findOne({ _id: message.rid })

			if Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) is -1
				return false
			
			return true
		order: 5
