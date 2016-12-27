Meteor.startup ->
	unless TAGT.models.Permissions.findOneById( 'view-user-activity')?
		TAGT.models.Permissions.upsert( 'view-user-activity', { $setOnInsert : { _id: 'view-user-activity', roles : ['admin', 'user'] } })

	TAGT.settings.addGroup('Activity');

	TAGT.settings.add('User_Activity_Enabled', true, { type: 'boolean', group: 'Activity', i18nLabel: 'Enabled' })
	