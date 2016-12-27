Meteor.publish 'userDebates', ->
	unless this.userId
		return this.ready()

	if TAGT.authz.hasPermission( @userId, 'view-debate')
		record = TAGT.models.Debates.findList {"u._id": this.userId},
			{
				fields:
					name: 1
					u: 1
					ts: 1
					htmlBody: 1
			}
		console.log record.fetch()
		return record
	else
		return @ready()