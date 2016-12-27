Meteor.publish 'rooms', () ->
	unless this.userId
		return this.ready()

	user = TAGT.models.Users.findOneById this.userId


	TAGT.models.Rooms.findByUsername user.username,
		fields:
			_id: 1
			usernames: 1