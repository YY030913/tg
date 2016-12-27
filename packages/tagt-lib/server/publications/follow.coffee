Meteor.publish 'follow', (slug) ->
	unless this.userId
		return this.ready()

	publication = @

	if TAGT.authz.hasPermission( @userId, 'view-user-profile')
		cursorHandle = TAGT.models.Friend.findByUser(slug, { 
			sort: { 
				ts: -1 
			},
			fields: {
				_id: 1
				friend: 1
				pinyin: 1
				u: 1
				ts: 1
				del: 1
			}
		}).observeChanges
			added: (_id, record) ->
				publication.added('tagt_follow', _id, record)

			changed: (_id, record) ->
				publication.changed('tagt_follow', _id, record)

			removed: (_id) ->
				publication.removed('tagt_follow', _id)

		cursorHandleFriend = TAGT.models.Friend.findByFriend(slug, { 
			sort: { 
				ts: -1 
			}, 
			fields: {
				_id: 1
				friend: 1
				pinyin: 1
				u: 1
				ts: 1
				del: 1
			}
		}).observeChanges
			added: (_id, record) ->
				publication.added('tagt_follow', _id, record)

			changed: (_id, record) ->
				publication.changed('tagt_follow', _id, record)

			removed: (_id) ->
				publication.removed('tagt_follow', _id)

	@ready()