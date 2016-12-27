TAGT.Migrations.add
	version: 31
	up: ->
		changes =
			API_Analytics: 'GoogleTagManager_id'

		for from, to of changes
			record = TAGT.models.Settings.findOne _id: from
			if record?
				delete record._id
				TAGT.models.Settings.upsert {_id: to}, record
			TAGT.models.Settings.remove _id: from
