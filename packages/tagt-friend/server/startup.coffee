Meteor.startup ->
	unless TAGT.models.Permissions.findOneById( 'view-user-friend')?
		TAGT.models.Permissions.upsert( 'view-user-friend', { $setOnInsert : { _id: 'view-user-friend', roles : ['admin', 'user'] } })

	TAGT.settings.addGroup('Friend');

	TAGT.settings.add('User_Friend_Enabled', true, { type: 'boolean', group: 'Friend', i18nLabel: 'Enabled' });