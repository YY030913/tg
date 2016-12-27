Meteor.publish 'roleAutocomplete', (selector) ->
	unless this.userId
		return this.ready()

	pub = this

	options =
		fields:
			name: 1
		limit: 10
		sort:
			name: 1

	exceptions = selector.exceptions or []

	cursorHandle = TAGT.models.Roles.find({}, options).observeChanges
		added: (_id, record) ->
			if TAGT.models.Roles.isUserInRoles(this.userId, record.name)
				pub.added("autocompleteRecords", _id, record)
		changed: (_id, record) ->
			if TAGT.models.Roles.isUserInRoles(this.userId, record.name)
				pub.changed("autocompleteRecords", _id, record)
		removed: (_id, record) ->
			if TAGT.models.Roles.isUserInRoles(this.userId, record.name)
				pub.removed("autocompleteRecords", _id, record)
	@ready()
	@onStop ->
		cursorHandle.stop()
	return
