Meteor.startup ->
	unless TAGT.models.Permissions.findOneById( 'view-user-profile')?
		TAGT.models.Permissions.upsert( 'view-user-profile', { $setOnInsert : { _id: 'view-user-profile', roles : ['admin', 'user', 'owner'] } })

	unless TAGT.models.Permissions.findOneById( 'update-follow')?
		TAGT.models.Permissions.upsert( 'update-follow', { $setOnInsert : { _id: 'update-follow', roles : ['admin', 'user', 'owner'] } })


	TAGT.settings.addGroup('Profile');
	TAGT.settings.add('User_Profile_Enabled', true, { type: 'boolean', group: 'Profile', i18nLabel: 'Enabled', 'public': true })