Meteor.publish 'recommendDebates', ->
	unless this.userId
		return this.ready()

	TAGT.models.Debates.findList {
			recommend: true
			del: false
		},
		{
			fields:
				username: 1
				status: 1
				utcOffset: 1
			sort:
				ts: -1
		}
		
