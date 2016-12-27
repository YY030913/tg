Meteor.startup ->
	defaultMedals = [
		{ name: 'Medal_Start', description: 'Admin' }
		{ name: 'Medal_Kill', description: 'Moderator' }
		{ name: 'Medal_LEVEL_1', description: 'Owner' }
		{ name: 'Medal_LEVEL_2', description: '' }
		{ name: 'Medal_LEVEL_3', description: '' }
		{ name: 'Medal_LEVEL_4', description: '' }
		{ name: 'Medal_LEVEL_5', description: '' }
		{ name: 'Medal_LEVEL_6', description: '' }
		{ name: 'Medal_LEVEL_7', description: '' }

		{ name: 'Medal_Engineer', description: '' }
		{ name: 'Medal_Lighting', description: '' }
		{ name: 'Medal_Honor', description: '' }
		{ name: 'Medal_Flag', description: '' }
		{ name: 'Medal_Contribution', description: '' }
		{ name: 'Medal_Royal', description: '' }
		{ name: 'Medal_Soldier', description: '' }
		{ name: 'Medal_Token', description: '' }
		{ name: 'Medal_Best', description: '' }
	]

	for medal in defaultMedals
		TAGT.models.Medals.upsert { _id: medal.name }, { $setOnInsert: {description: medal.description || '', protected: true } }