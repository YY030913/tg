loadMissedDebates = (tid) ->
	lastDebate = Debates.findOne({"tags._id": tid}, {sort: {ts: -1}, limit: 1})
	if not lastDebate?
		return

	Meteor.call 'loadMissedDebates', tid, lastDebate.ts, (err, result) ->
		for item in result
			TAGT.promises.run('onClientMessageReceived', item).then (item) ->
				#item.roles = _.union(UserRoles.findOne(item.u?._id)?.roles, RoomRoles.findOne({tid: item.tid, 'u._id': item.u?._id})?.roles)
				Debates.upsert {_id: item._id}, item

connectionWasOnline = true
Tracker.autorun ->
	connected = Meteor.connection.status().connected

	if connected is true and connectionWasOnline is false and TagManager.openedTags?
		for key, value of TagManager.openedTags
			if value.tid?
				loadMissedDebates(value.tid)

	connectionWasOnline = connected


Meteor.startup ->
	Debates.find().observe
		removed: (record) ->
			if TagManager.getOpenedTagByFid(record.tid)?
				recordBefore = Debates.findOne {ts: {$lt: record.ts}}, {sort: {ts: -1}}
				if recordBefore?
					Debates.update {_id: recordBefore._id}, {$set: {tick: new Date}}

				recordAfter = Debates.findOne {ts: {$gt: record.ts}}, {sort: {ts: 1}}
				if recordAfter?
					Debates.update {_id: recordAfter._id}, {$set: {tick: new Date}}


onDeleteMessageStream = (msg) ->
	Debates.remove _id: msg._id


Tracker.autorun ->
	if Meteor.userId()
		TAGT.Notifications.onUser 'message', (msg) ->
			msg.u =
				username: 'rocketbot'
			msg.private = true

			Debates.upsert { _id: msg._id }, msg


@TagManager = new class
	openedTags = {}
	subscription = null
	tagStream = new Meteor.Streamer 'tag-debates'
	onlineUsers = new ReactiveVar {}

	Dep = new Tracker.Dependency

	init = ->
		subscription = Meteor.subscribe('debateSubscription')
		return subscription


	close = (typeName) ->
		if openedTags[typeName]
			if openedTags[typeName].sub?
				for sub in openedTags[typeName].sub
					sub.stop()

			if openedTags[typeName].tid?
				tagStream.removeAllListeners openedTags[typeName].tid
				TAGT.Notifications.unRoom openedTags[typeName].tid, 'deleteMessage', onDeleteMessageStream

			openedTags[typeName].ready = false
			openedTags[typeName].active = false
			if openedTags[typeName].template?
				Blaze.remove openedTags[typeName].template
			delete openedTags[typeName].dom
			delete openedTags[typeName].template

			tid = openedTags[typeName].tid
			delete openedTags[typeName]

			if tid?
				DebatesManager.clear tid


	computation = Tracker.autorun ->
		for typeName, record of openedTags when record.active is true
			do (typeName, record) ->
				user = Meteor.user()
				unless user?.username
					return

				record.sub = [
					Meteor.subscribe 'tag', typeName
				]

				if record.ready is true
					return

				ready = record.sub[0].ready() and subscription.ready()

				if ready is true
					type = typeName.substr(0, 1)
					name = typeName.substr(1)

					tag = Tracker.nonreactive =>
						return TAGT.tagTypes.findTag(type, name, user)
					if not tag?
						record.ready = true
					else
						openedTags[typeName].tid = tag._id

						DebatesManager.getMoreIfIsEmpty tag._id
						record.ready = DebatesManager.isLoading(tag._id) is false
						Dep.changed()
						if openedTags[typeName].streamActive isnt true
							openedTags[typeName].streamActive = true

							tagStream.on openedTags[typeName].tid, (debate) ->
								#console.log "msgStream.on openedTags", openedTags, debate
								TAGT.promises.run('onClientMessageReceived', debate).then (debate) ->

									# Should not send message to tag if tag has not loaded all the current messages
									if DebatesManager.hasMoreNext(openedTags[typeName].tid) is false

										#debate.roles = _.union(UserRoles.findOne(debate.u?._id)?.roles, RoomRoles.findOne({tid: debate.tid, 'u._id': debate.u?._id})?.roles)
										Debates.upsert { _id: debate._id }, debate

										Meteor.defer ->
											TagManager.updateMentionsMarksOfRoom typeName

										TAGT.callbacks.run 'streamMessage', debate

							TAGT.Notifications.onRoom openedTags[typeName].tid, 'deleteMessage', onDeleteMessageStream

				Dep.changed()


	closeOlderTags = ->
		maxTagsOpen = 10
		if Object.keys(openedTags).length <= maxTagsOpen
			return

		tagsToClose = _.sortBy(_.values(openedTags), 'lastSeen').reverse().slice(maxTagsOpen)
		for tagToClose in tagsToClose
			close tagToClose.typeName


	closeAllTags = ->
		for key, openedTag of openedTags
			close openedTag.typeName


	open = (typeName) ->
		if not openedTags[typeName]?
			if typeName.substr(0, 1) == "o"
				pageTitle = t(typeName.substr(1))
			else
				pageTitle = typeName.substr(1)
			openedTags[typeName] =
				typeName: typeName
				active: false
				ready: false
				unreadSince: new ReactiveVar undefined
				pageTitle: pageTitle

		openedTags[typeName].lastSeen = new Date

		if openedTags[typeName].ready
			closeOlderTags()

		if subscription.ready() && Meteor.userId()

			if openedTags[typeName].active isnt true
				openedTags[typeName].active = true
				computation?.invalidate()

		return {
			ready: ->
				Dep.depend()
				return openedTags[typeName].ready
		}

	getOpenedTagByFid = (tid) ->
		for typeName, openedTag of openedTags
			if openedTag.tid is tid
				return openedTag

	getDomOfTag = (typeName, tid) ->
		tag = openedTags[typeName]
		if not tag?
			return

		if ((not tag.dom?) and tid?) or (tag.dom? and tag.dom.querySelector('.debate-list')? and tag.dom.querySelector('.debate-list').children?.length == 0)
			tag.dom = document.createElement 'div'
			tag.dom.classList.add 'tag-container'
			contentAsFunc = (content) ->
				return -> content

			tag.template = Blaze._TemplateWith { _id: tag.tid, pageTitle: tag.pageTitle }, contentAsFunc(Template.debateTag)
			Blaze.render tag.template, tag.dom #, nextNode, parentView
		return tag.dom

	existsDomOfRoom = (typeName) ->
		tag = openedTags[typeName]
		return tag?.dom?

	updateUserStatus = (user, status, utcOffset) ->
		onlineUsersValue = onlineUsers.curValue

		if status is 'offline'
			delete onlineUsersValue[user.username]
		else
			onlineUsersValue[user.username] =
				_id: user._id
				status: status
				utcOffset: utcOffset

		onlineUsers.set onlineUsersValue

	updateMentionsMarksOfRoom = (typeName) ->
		dom = getDomOfTag typeName
		if not dom?
			return

		ticksBar = $(dom).find('.ticks-bar')
		$(dom).find('.ticks-bar > .tick').remove()

		scrollTop = $(dom).find('.messages-box > .wrapper').scrollTop() - 50
		totalHeight = $(dom).find('.messages-box > .wrapper > ul').height() + 40

		$('.messages-box .mention-link-me').each (index, item) ->
			topOffset = $(item).offset().top + scrollTop
			percent = 100 / totalHeight * topOffset
			if $(item).hasClass('mention-link-all')
				ticksBar.append('<div class="tick tick-all" style="top: '+percent+'%;"></div>')
			else
				ticksBar.append('<div class="tick" style="top: '+percent+'%;"></div>')

	open: open
	close: close
	closeAllTags: closeAllTags
	init: init
	getDomOfTag: getDomOfTag
	existsDomOfRoom: existsDomOfRoom
	tagStream: tagStream
	openedTags: openedTags
	updateUserStatus: updateUserStatus
	onlineUsers: onlineUsers
	updateMentionsMarksOfRoom: updateMentionsMarksOfRoom
	getOpenedTagByFid: getOpenedTagByFid


TAGT.callbacks.add 'afterLogoutCleanUp', ->
	TagManager.closeAllTags()
