Meteor.startup ->
	beforeCreateScoreCallback = (score) ->
		Tracker.nonreactive ->
			if score?.htmlBody?
				score.imgs = TAGT.utils.stripImgSrcs score.htmlBody
				score.txt = TAGT.utils.stripHTML score.htmlBody

		return score

	TAGT.callbacks.add 'beforeCreateScore', beforeCreateScoreCallback, TAGT.callbacks.priority.HIGH

	afterCreateScoreCallback = (score) ->
		Tracker.nonreactive ->
			if score?.htmlBody?
				TAGT.models.ScoreHistories.insert(score)
		return score

	TAGT.callbacks.add 'afterCreateScore', afterCreateScoreCallback, TAGT.callbacks.priority.HIGH
