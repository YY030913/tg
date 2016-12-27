Meteor.publish 'typeSelectTag',  ->
	unless this.userId
		return this.ready()

	
	return TAGT.models.Tags.findForUser(this.userId)