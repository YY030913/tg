Meteor.methods
	'public-settings/get': ->
		this.unblock()

		return TAGT.models.Settings.findNotHiddenPublic().fetch()

	'public-settings/sync': (updatedAt) ->
		this.unblock()

		result =
			update: TAGT.models.Settings.findNotHiddenPublicUpdatedAfter(updatedAt).fetch()
			remove: TAGT.models.Settings.trashFindDeletedAfter(updatedAt, {hidden: { $ne: true }, public: true}, {fields: {_id: 1, _deletedAt: 1}}).fetch()

		return result

	'private-settings/get': ->
		unless Meteor.userId()
			return []

		this.unblock()

		if not TAGT.authz.hasPermission Meteor.userId(), 'view-privileged-setting'
			return []

		return TAGT.models.Settings.findNotHidden().fetch()

	'private-settings/sync': (updatedAt) ->
		unless Meteor.userId()
			return {}

		this.unblock()

		return TAGT.models.Settings.dinamicFindChangesAfter('findNotHidden', updatedAt);


TAGT.models.Settings.on 'change', (type, args...) ->
	records = TAGT.models.Settings.getChangedRecords type, args[0]

	for record in records
		if record.public is true
			TAGT.Notifications.notifyAll 'public-settings-changed', type, _.pick(record, '_id', 'value')

		TAGT.Notifications.notifyAll 'private-settings-changed', type, record


TAGT.Notifications.streamAll.allowRead 'private-settings-changed', ->
	if not @userId? then return false

	return TAGT.authz.hasPermission @userId, 'view-privileged-setting'
