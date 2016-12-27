Meteor.startup ->
	unless TAGT.models.Permissions.findOneById( 'access-debate-tag')?
		TAGT.models.Permissions.upsert( 'access-debate-tag', { $setOnInsert : { _id: 'access-debate-tag', roles : ['admin', 'user', 'owner'] } })
	unless TAGT.models.Permissions.findOneById( 'view-debate')?
		TAGT.models.Permissions.upsert( 'view-debate', { $setOnInsert : { _id: 'view-debate', roles : ['admin', 'user', 'owner'] } })

	unless TAGT.models.Permissions.findOneById( 'create-debate')?
		TAGT.models.Permissions.upsert( 'create-debate', { $setOnInsert : { _id: 'create-debate', roles : ['admin', 'user', 'owner'] } })

	unless TAGT.models.Permissions.findOneById( 'update-debate')?
		TAGT.models.Permissions.upsert( 'update-debate', { $setOnInsert : { _id: 'update-debate', roles : ['admin', 'owner'] } })

	unless TAGT.models.Permissions.findOneById( 'update-debate-tag')?
		TAGT.models.Permissions.upsert( 'update-debate-tag', { $setOnInsert : { _id: 'update-debate-tag', roles : ['admin', 'owner', 'DebateSubscriptions'] } })

	unless TAGT.models.Permissions.findOneById( 'update-debate-read')?
		TAGT.models.Permissions.upsert( 'update-debate-read', { $setOnInsert : { _id: 'update-debate-read', roles : ['admin', 'owner', 'user'] } })

	unless TAGT.models.Permissions.findOneById( 'update-debate-share')?
		TAGT.models.Permissions.upsert( 'update-debate-share', { $setOnInsert : { _id: 'update-debate-share', roles : ['admin', 'owner', 'user'] } })

	unless TAGT.models.Permissions.findOneById( 'update-debate-favorite')?
		TAGT.models.Permissions.upsert( 'update-debate-favorite', { $setOnInsert : { _id: 'update-debate-favorite', roles : ['admin', 'owner', 'user'] } })

	unless TAGT.models.Permissions.findOneById( 'view-user-debates')?
		TAGT.models.Permissions.upsert( 'view-user-debates', { $setOnInsert : { _id: 'view-user-debates', roles : ['admin', 'owner'] } })

	unless TAGT.models.Permissions.findOneById( 'join-tag')?
		TAGT.models.Permissions.upsert( 'join-tag', { $setOnInsert : { _id: 'join-tag', roles : ['admin', 'owner', 'user'] } })

	unless TAGT.models.Permissions.findOneById( 'webrtc-join')?
		TAGT.models.Permissions.upsert( 'webrtc-join', { $setOnInsert : { _id: 'webrtc-join', roles : ['admin', 'owner', 'user'] } })



	TAGT.settings.addGroup('Rule');
	#TAGT.settings.add('User_Rule_Enabled', true, { type: 'boolean', group: 'Rule', i18nLabel: 'Enabled', 'public': true })
	