Meteor.startup ->
	Meteor.setTimeout ->
		msg = [
			"     Version: #{TAGT.Info.version}"
			"Process Port: #{process.env.PORT}"
			"    Site URL: #{TAGT.settings.get('Site_Url')}"
		].join('\n')

		SystemLogger.startup_box msg, 'SERVER RUNNING'
	, 100
