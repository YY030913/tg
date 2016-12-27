Meteor.publish 'debateSubscription', ->
	unless this.userId
		return this.ready()

	record = TAGT.models.DebateSubscriptions.findByUserId this.userId,
		fields:
			t: 1
			ts: 1
			ls: 1
			name: 1
			fid: 1
			code: 1
			f: 1
			open: 1
			alert: 1
			unread: 1
			archived: 1
			desktopNotifications: 1
			mobilePushNotifications: 1
			emailNotifications: 1
			
	return record
