Meteor.publish 'privateHistory', ->
	unless this.userId
		return this.ready()

	TAGT.models.Rooms.findByContainigUsername TAGT.models.Users.findOneById(this.userId).username,
		fields:
			t: 1
			name: 1
			msgs: 1
			ts: 1
			lm: 1
			cl: 1

