Meteor.startup ->
	unless TAGT.models.Permissions.findOneById( 'view-user-score')?
		TAGT.models.Permissions.upsert( 'view-user-score', { $setOnInsert : { _id: 'view-user-score', roles : ['admin', 'user'] } })

	TAGT.settings.addGroup('Score');

	TAGT.settings.add('User_Score_Enabled', true, { type: 'boolean', group: 'Score', i18nLabel: 'Enabled' });