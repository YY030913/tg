Meteor.publish 'searchHistroy', () ->
	unless this.userId
		return this.ready()

	TAGT.models.Searchs.findByUser this.userId,
		fields:
			name: 1
			u: 1
			ts: 1

