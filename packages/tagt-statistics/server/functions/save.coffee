TAGT.statistics.save = ->
	statistics = TAGT.statistics.get()
	statistics.createdAt = new Date
	TAGT.models.Statistics.insert statistics
	return statistics

