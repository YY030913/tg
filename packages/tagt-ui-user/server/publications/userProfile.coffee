Meteor.publish 'userProfile', (id) ->
	unless id
		id = this.userId

	options =
		fields:
			username: 1
			name: 1
			statusConnection: 1
		sort:
			username: 1

		limit: 1

	pub = this
	
	cursorHandle = TAGT.models.Users.findById(id, options).observeChanges
		added: (_id, record) ->
			pub.added('profile-users', _id, record)

		changed: (_id, record) ->
			pub.changed('profile-users', _id, record)

		removed: (_id, record) ->
			pub.removed('profile-users', _id, record)

	@ready()
	@onStop ->
		cursorHandle.stop()
	return
