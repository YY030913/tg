Meteor.startup ->
	###
	defaultMedals = [
		{ name: 'welcome', cover:'', url:'images/ad.jpg', title:'welcome', description: 'Admin' }
	]

	for medal in defaultMedals
		TAGT.models.Ad.upsert { _id: medal.name }, { $setOnInsert: {description: medal.description || '', protected: true } }
	###

	unless TAGT.models.Permissions.findOneById('manage-ads')?
		TAGT.models.Permissions.upsert( 'manage-ads', { $setOnInsert : { _id: 'manage-ads', roles : ['admin'] } })

	unless TAGT.models.Permissions.findOneById('create-ad')?
		TAGT.models.Permissions.upsert( 'create-ad', { $setOnInsert : { _id: 'create-ad', roles : ['admin'] } })