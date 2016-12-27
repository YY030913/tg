Meteor.startup ->
	beforeCreateDebateCallback = (debate) ->
		Tracker.nonreactive ->
			if debate?.htmlBody?
				debate.htmlBody = TAGT.utils.extendRemoveImgSrcs debate.htmlBody
				# debate.imgs = TAGT.utils.stripImgSrcs debate.htmlBody
				debate.txt = TAGT.utils.stripHTML debate.htmlBody

				###
				SummaryTool.summarize '', debate.txt, (err, summary)->
					debate.summary = summary
				###

		return debate

	TAGT.callbacks.add 'beforeCreateDebate', beforeCreateDebateCallback, TAGT.callbacks.priority.HIGH

	afterCreateDebateCallback = (debate) ->
		Tracker.nonreactive ->
			if debate?.htmlBody?
				TAGT.models.DebateHistories.createDebate(debate)

				if TAGT.models.Activity.find({userId: Meteor.userId(), "operator": "create_debate", href: "/debate/#{debate._id}"}).count() > 0
					
					if debate.save
						activity = TAGT.Activity.utils.add(debate.name, debate.abstracttml, 'update_debate', 'Update_Debae', "/debate/#{debate._id}")
						
					
						activity.userId = Meteor.userId()
						TAGT.models.Activity.createActivity(activity)
				else
					if debate.save
						
						exist = TAGT.models.Users.findOne {_id: Meteor.userId(), "debates._id": debate._id},
							fields:
								debates: 1

						if exist?
							activity = TAGT.Activity.utils.add(debate.name, debate.abstracttml, 'change_debate', 'Change_Debae', "/debate/#{debate._id}")
							
							activity.userId = Meteor.userId()
							TAGT.models.Activity.createActivity(activity)
						else
							activity = TAGT.Activity.utils.add(debate.name, debate.abstracttml, 'create_debate', 'Create_Debae', "/debate/#{debate._id}")
							
							activity.userId = Meteor.userId()
							TAGT.models.Activity.createActivity(activity)

							score = TAGT.Score.utils.add("/debate/#{debate._id}", 'create_debate', 'Create_Debae')
							score.userId = Meteor.userId()
							score.score = TAGT.Score.utils.debateCreateScore
							TAGT.models.Score.create(score)

							TAGT.models.Users.addDebate Meteor.userId(), {_id: debate._id}
							TAGT.models.Users.addCreateDebate Meteor.userId(), {_id: debate._id}
							
		if debate.save?
			_.each(debate.tags, (element, index, list)->
				TAGT.models.DebateSubscriptions.incUnreadForTagIdExcludingUserId(element._id, Meteor.userId());
			)
			
		return debate

	TAGT.callbacks.add 'afterCreateDebate', afterCreateDebateCallback, TAGT.callbacks.priority.HIGH
