Meteor.publish 'userScore', (userid)->
	unless this.userId
		return this.ready()

	if userid
		queryUserId = userid
	else
		queryUserId = this.userId

	TAGT.models.Score.findByUserId queryUserId


