Meteor.methods
	loadDebates: (tid, end, limit=20, ls) ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'loadDebates' }

		fromId = Meteor.userId()

		unless Meteor.call 'canAccessTag', tid, fromId
			return false

		options =
			sort:
				ts: -1
			limit: limit
		#if not TAGT.settings.get 'Message_ShowEditedStatus'
		#	options.fields = { 'editedAt': 0 }

		if end?
			records = TAGT.models.Debates.findVisibleByTagIdBeforeTimestamp(tid, end, options).fetch()
		else
			records = TAGT.models.Debates.findVisibleByTagId(tid, options).fetch()

		debates = _.map records, (debate) ->
			debate.starred = _.findWhere debate.starred, { _id: fromId }
			return debate

		unreadNotLoaded = 0

		delete options.limit

		if records.length == 0
			nextloadDebates = 0
		else
			firstDebate = records[0]
			lastDebate = records[records.length - 1]
		

			nextloadDebates = TAGT.models.Debates.findVisibleByTagIdBeforeTimestamp(tid, lastDebate.ts, { limit: 1, sort: { ts: -1 } }).count()

			if ls?
				unreadDebates = TAGT.models.Debates.findVisibleByTagIdAfterTimestamp(tid, firstDebate.ts, { limit: 1, sort: { ts: -1 } })
				firstUnread = unreadDebates.fetch()[0]
				unreadNotLoaded = unreadDebates.count()

		TAGT.models.DebateSubscriptions.setAsReadByTagIdAndUserId tid, Meteor.userId()

		return {
			nextloadDebates: nextloadDebates
			debates: debates
			firstUnread: firstUnread
			unreadNotLoaded: unreadNotLoaded
		}