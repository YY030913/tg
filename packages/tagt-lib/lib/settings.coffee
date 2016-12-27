###
# TAGT.settings holds all packages settings
# @namespace TAGT.settings
###
TAGT.settings =
	callbacks: {}
	ts: new Date

	get: (_id) ->
		return Meteor.settings?[_id]

	get: (_id, callback) ->
		if callback?
			TAGT.settings.onload _id, callback
			if _id is '*' and Meteor.settings?
				for key, value of Meteor.settings
					callback key, value
				return

			if Meteor.settings?[_id]?
				callback _id, Meteor.settings?[_id]
		else
			return Meteor.settings?[_id]

	set: (_id, value, callback) ->
		Meteor.call 'saveSetting', _id, value, callback

	batchSet: (settings, callback) ->

		# async -> sync
		# http://daemon.co.za/2012/04/simple-async-with-only-underscore/

		save = (setting) ->
			return (callback) ->
				Meteor.call 'saveSetting', setting._id, setting.value, callback

		actions = _.map settings, (setting) -> save(setting)
		_(actions).reduceRight(_.wrap, (err, success) -> return callback err, success)()

	load: (key, value, initialLoad) ->
		if TAGT.settings.callbacks[key]?
			for callback in TAGT.settings.callbacks[key]
				callback key, value, initialLoad

		if TAGT.settings.callbacks['*']?
			for callback in TAGT.settings.callbacks['*']
				callback key, value, initialLoad


	onload: (key, callback) ->
		# if key is '*'
		# 	for key, value in Meteor.settings
		# 		callback key, value, false
		# else if Meteor.settings?[_id]?
		# 	callback key, Meteor.settings[_id], false

		keys = [].concat key

		for k in keys
			TAGT.settings.callbacks[k] ?= []
			TAGT.settings.callbacks[k].push callback
