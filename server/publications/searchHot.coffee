Meteor.publish 'searchHot', () ->
	unless this.userId
		return this.ready()

	TAGT.models.Searchs.findHot
		fields:
			name: 1
			ts: 1
			t: 1

