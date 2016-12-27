Meteor.publish 'ads', () ->
	unless this.userId
		return this.ready()

	TAGT.models.Ad.findAllOpen()