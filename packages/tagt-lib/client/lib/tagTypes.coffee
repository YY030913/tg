TAGT.tagTypes = new class
	tagTypesOrder = []
	tagTypes = {}
	mainOrder = 1

	### Adds a tag type to app
	@param identifier An identifier to the tag type. If a real tag, MUST BE the same of `db.tagt_tag.t` field, if not, can be null
	@param order Order number of the type
	@param config
		template: template name to render on sideNav
		icon: icon class
		route:
			name: route name
			action: route action function
	###
	add = (identifier, order, config) ->
		unless identifier?
			identifier = Random.id()

		if tagTypes[identifier]?
			return false

		if not order?
			order = mainOrder + 10
			mainOrder += 10

		# @TODO validate config options
		tagTypesOrder.push
			identifier: identifier
			order: order
		tagTypes[identifier] = config

		if config.route?.path? and config.route?.name? and config.route?.action?
			FlowRouter.route config.route.path,
				name: config.route.name
				action: config.route.action
				triggersExit: [roomExit]

	###
	@param tagType: tag type (e.g.: c (for channels), d (for direct channels))
	@param subData: the user's subscription data
	###
	getRouteLink = (tagType, subData) ->
		unless tagTypes[tagType]?
			return false

		return FlowRouter.path tagTypes[tagType].route.name, tagTypes[tagType].route.link(subData)

	checkCondition = (tagType) ->
		return not tagType.condition? or tagType.condition()

	getAllTypes = ->
		orderedTypes = []

		_.sortBy(tagTypesOrder, 'order').forEach (type) ->
			orderedTypes.push tagTypes[type.identifier]

		return orderedTypes

	getIcon = (tagType) ->
		return tagTypes[tagType]?.icon

	getTagName = (tagType, tagData) ->
		return tagTypes[tagType]?.tagName tagData

	getIdentifiers = (except) ->
		except = [].concat except
		list = _.reject tagTypesOrder, (t) -> return except.indexOf(t.identifier) isnt -1
		return _.map list, (t) -> return t.identifier

	findTag = (tagType, identifier, user) ->
		return tagTypes[tagType]?.findTag identifier, user

	# addType: addType
	getTypes: getAllTypes
	getIdentifiers: getIdentifiers

	findTag: findTag

	# setIcon: setIcon
	getIcon: getIcon
	getTagName: getTagName

	# setRoute: setRoute
	getRouteLink: getRouteLink

	checkCondition: checkCondition

	add: add
