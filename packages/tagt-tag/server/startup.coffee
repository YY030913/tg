Meteor.startup ->
	unless TAGT.models.Permissions.findOneById('access-tag')?
		TAGT.models.Permissions.upsert( 'access-tag', { $setOnInsert : { _id: 'access-tag', roles : ['admin', 'user'] } })

	unless TAGT.models.Permissions.findOneById('manage-tags')?
		TAGT.models.Permissions.upsert( 'manage-tags', { $setOnInsert : { _id: 'manage-tags', roles : ['admin'] } })

	unless TAGT.models.Permissions.findOneById('manage-own-tags')?
		TAGT.models.Permissions.upsert( 'manage-own-tags', { $setOnInsert : { _id: 'manage-own-tags', roles : ['admin', 'owner'] } })

	unless TAGT.models.Permissions.findOneById('create-o-tag')?
		TAGT.models.Permissions.upsert( 'create-o-tag', { $setOnInsert : { _id: 'create-o-tag', roles : ['admin', 'user'] } })

	unless TAGT.models.Permissions.findOneById('create-h-tag')?
		TAGT.models.Permissions.upsert( 'create-h-tag', { $setOnInsert : { _id: 'create-h-tag', roles : ['admin'] } })

	unless TAGT.models.Permissions.findOneById('create-u-tag')?
		TAGT.models.Permissions.upsert( 'create-u-tag', { $setOnInsert : { _id: 'create-u-tag', roles : ['admin', 'user'] } })
	
	unless TAGT.models.Permissions.findOneById('view-o-tag')?
		TAGT.models.Permissions.upsert( 'view-o-tag', { $setOnInsert : { _id: 'view-o-tag', roles : ['admin', 'user'] } })

	unless TAGT.models.Permissions.findOneById('view-h-tag')?
		TAGT.models.Permissions.upsert( 'view-h-tag', { $setOnInsert : { _id: 'view-h-tag', roles : ['admin'] } })

	unless TAGT.models.Permissions.findOneById('view-u-tag')?
		TAGT.models.Permissions.upsert( 'view-u-tag', { $setOnInsert : { _id: 'view-u-tag', roles : ['admin', 'user'] } })

	unless TAGT.models.Permissions.findOneById('view-joined-tag')?
		TAGT.models.Permissions.upsert( 'view-joined-tag', { $setOnInsert : { _id: 'view-joined-tag', roles : ['admin'] } })

	Meteor.defer ->

		if not TAGT.models.Tags.findOneByNameAndType('Pk', 'o')?
			TAGT.models.Tags.createWithIdTypeAndName 'o', 'Pk',
				showOnSelectType: ['user', 'admin']
				default: true
			pktag = TAGT.models.Tags.findOneByNameAndType 'Pk', 'o'
			TAGT.models.DebateSubscriptions.createWithTagAndUser pktag, {_id: 'tagt', username: 'tagt'}, {editable: false}

		if not TAGT.models.Tags.findOneByNameAndType('Society_Topic', 'o')?
			TAGT.models.Tags.createWithIdTypeAndName 'o', 'Society_Topic',
				showOnSelectType: ['user', 'admin']
				default: true
			societytag = TAGT.models.Tags.findOneByNameAndType 'Society_Topic', 'o'
			TAGT.models.DebateSubscriptions.createWithTagAndUser societytag, {_id: 'tagt', username: 'tagt'}, {editable: false}

		if not TAGT.models.Tags.findOneByNameAndType('Hot', 'o')?
			TAGT.models.Tags.createWithIdTypeAndName 'o', 'Hot',
				showOnSelectType: ['admin']
				default: true
			hottag = TAGT.models.Tags.findOneByNameAndType 'Hot', 'o'
			TAGT.models.DebateSubscriptions.createWithTagAndUser hottag, {_id: 'tagt', username: 'tagt'}, {editable: false}

		if not TAGT.models.Tags.findOneByNameAndType('News', 'o')?
			TAGT.models.Tags.createWithIdTypeAndName 'o', 'News', 
				showOnSelectType: ['admin']
				default: true
			newstag = TAGT.models.Tags.findOneByNameAndType 'News', 'o'
			TAGT.models.DebateSubscriptions.createWithTagAndUser newstag, {_id: 'tagt', username: 'tagt'}, {editable: false}

		if not TAGT.models.Tags.findOneByNameAndType('Institution_Match', 'o')?
			TAGT.models.Tags.createWithIdTypeAndName 'o', 'Institution_Match', 
				showOnSelectType: ['institution', 'admin']
				default: true
			institutiontag = TAGT.models.Tags.findOneByNameAndType 'Institution_Match', 'o'
			TAGT.models.DebateSubscriptions.createWithTagAndUser institutiontag, {_id: 'tagt', username: 'tagt'}, {editable: false}

		if not TAGT.models.Tags.findOneByNameAndType('Company_Discuss', 'o')?
			TAGT.models.Tags.createWithIdTypeAndName 'o', 'Company_Discuss', 
				showOnSelectType: ['company', 'admin']
				default: true
			companytag = TAGT.models.Tags.findOneByNameAndType 'Company_Discuss', 'o'
			TAGT.models.DebateSubscriptions.createWithTagAndUser companytag, {_id: 'tagt', username: 'tagt'}, {editable: false}

		if not TAGT.models.Tags.findOneByNameAndType('Organization_Activity', 'o')?
			TAGT.models.Tags.createWithIdTypeAndName 'o', 'Organization_Activity', 
				showOnSelectType: ['organization', 'admin']
				default: true
			organizationtag = TAGT.models.Tags.findOneByNameAndType 'Organization_Activity', 'o'
			TAGT.models.DebateSubscriptions.createWithTagAndUser organizationtag, {_id: 'tagt', username: 'tagt'}, {editable: false}


		if not TAGT.models.Tags.findOneByNameAndType('Government_Interpretation', 'o')?
			TAGT.models.Tags.createWithIdTypeAndName 'o', 'Government_Interpretation', 
				showOnSelectType: ['government', 'admin']
				default: true
			governmenttag = TAGT.models.Tags.findOneByNameAndType 'Government_Interpretation', 'o'
			TAGT.models.DebateSubscriptions.createWithTagAndUser governmenttag, {_id: 'tagt', username: 'tagt'}, {editable: false}


	TAGT.tagTypes.setPublish 'o', (code)->
		return TAGT.models.Tags.findByTypeAndName 'o', code, 
			name: 1,
			t: 1,
			cl: 1,
			u: 1,
			label: 1,
			usernames: 1,
			v: 1,
			livechatData: 1,
			topic: 1,
			tags: 1,
			sms: 1,
			code: 1,
			open: 1
		if TAGT.authz.hasPermission(this.userId, 'view-o-tag')
			return TAGT.models.Tags.findByTypeAndName 'o', code, options
		return this.ready()