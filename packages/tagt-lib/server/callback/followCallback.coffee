Meteor.startup ->
	afterAddFollowCallback = (follow) ->
		Tracker.nonreactive ->
			user = Meteor.user()
			content = "#{follow.u.name} #{TAPi18n.__("Follow", { lng: user?.language || TAGT.settings.get('language') || 'en' })} #{follow.friend.name}"
			activity = TAGT.Activity.utils.add(TAPi18n.__("Follow", { lng: user?.language || TAGT.settings.get('language') || 'en' }), content, 'add_follow', 'Add_Follow')
			activity.userId = Meteor.userId()
			TAGT.models.Activity.createActivity(activity)
			# score = TAGT.Score.utils.addDebate(debate, 'create_debate', 'Create_Debae')
			# TAGT.models.Score.update(Meteor.userId(), score, TAGT.Score.utils.debateCreateScore)

	TAGT.callbacks.add 'afterAddFollow', afterAddFollowCallback, TAGT.callbacks.priority.HIGH

	afterCancelFollowCallback = (follow) ->
		Tracker.nonreactive ->
			user = Meteor.user()
			content = "#{follow.u.name} #{TAPi18n.__('Cancel_Follow', { lng: user?.language || TAGT.settings.get('language') || 'en' })} #{follow.friend.name}"
			activity = TAGT.Activity.utils.add(TAPi18n.__("Cancel_Follow", { lng: user?.language || TAGT.settings.get('language') || 'en' }), content, 'cancel_follow', 'Cancel_Follow')
			
			activity.userId = Meteor.userId()
			TAGT.models.Activity.createActivity(activity)
			# score = TAGT.Score.utils.addDebate(debate, 'create_debate', 'Create_Debae')
			# TAGT.models.Score.update(Meteor.userId(), score, TAGT.Score.utils.debateCreateScore)

	TAGT.callbacks.add 'afterCancelFollow', afterCancelFollowCallback, TAGT.callbacks.priority.HIGH
