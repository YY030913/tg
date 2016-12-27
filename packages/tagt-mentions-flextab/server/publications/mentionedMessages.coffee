Meteor.publish 'mentionedMessages', (rid, limit=50) ->
	unless this.userId
		return this.ready()

	publication = @

	user = TAGT.models.Users.findOneById this.userId
	unless user
		return this.ready()

	cursorHandle = TAGT.models.Messages.findVisibleByMentionAndRoomId(user.username, rid, { sort: { ts: -1 }, limit: limit }).observeChanges
		added: (_id, record) ->
			record.mentionedList = true
			publication.added('tagt_mentioned_message', _id, record)

		changed: (_id, record) ->
			record.mentionedList = true
			publication.changed('tagt_mentioned_message', _id, record)

		removed: (_id) ->
			publication.removed('tagt_mentioned_message', _id)

	@ready()
	@onStop ->
		cursorHandle.stop()
