TAGT.models.Medals = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'medals'
		@tryEnsureIndex { 'name': 1 }

	findUsersInRole: (name, options) ->
		medal = @findOne name
		TAGT.models['Users']?.findUsersInMedals?(name, options)

	isUserInMedals: (userId, medals) ->
		medals = [].concat medals
		_.some medals, (medalName) =>
			medal = @findOne medalName
			return TAGT.models['Users']?.isUserInRole?(userId, medalName)

	createOrUpdate: (name, description, protectedRole) ->
		updateData = {}
		updateData.name = name
		if description?
			updateData.description = description
		if protectedRole?
			updateData.protected = protectedRole

		@upsert { _id: name }, { $set: updateData }

	addUserMedals: (userId, medals) ->
		medals = [].concat medals
		console.log medals
		for medalName in medals
			medal = @findOne medalName
			TAGT.models['Users']?.addMedalsByUserId?(userId, medalName)

	removeUserMedals: (userId, medals) ->
		medals = [].concat medals
		for medalName in medals
			medal = @findOne medalName
			TAGT.models['Users']?.removeMedalsByUserId?(userId, medalName)
