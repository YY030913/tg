TAGT.Migrations.add
	version: 29
	up: ->
		LDAP_Url = TAGT.models.Settings.findOne('LDAP_Url')?.value
		LDAP_TLS = TAGT.models.Settings.findOne('LDAP_TLS')?.value
		LDAP_DN = TAGT.models.Settings.findOne('LDAP_DN')?.value
		LDAP_Bind_Search = TAGT.models.Settings.findOne('LDAP_Bind_Search')?.value

		if LDAP_Url? and LDAP_Url.trim() isnt ''
			LDAP_Url = LDAP_Url.replace(/ldaps?:\/\//i, '')
			TAGT.models.Settings.upsert
				_id: 'LDAP_Host'
			,
				$set:
					value: LDAP_Url
				$setOnInsert:
					createdAt: new Date

		if LDAP_TLS is true
			TAGT.models.Settings.upsert
				_id: 'LDAP_Encryption'
			,
				$set:
					value: 'tls'
				$setOnInsert:
					createdAt: new Date

		if LDAP_DN? and LDAP_DN.trim() isnt ''
			TAGT.models.Settings.upsert
				_id: 'LDAP_Domain_Base'
			,
				$set:
					value: LDAP_DN
				$setOnInsert:
					createdAt: new Date

			TAGT.models.Settings.upsert
				_id: 'LDAP_Username_Field'
			,
				$set:
					value: ''
				$setOnInsert:
					createdAt: new Date

			TAGT.models.Settings.upsert
				_id: 'LDAP_Unique_Identifier_Field'
			,
				$set:
					value: ''
				$setOnInsert:
					createdAt: new Date

		if LDAP_Bind_Search? and LDAP_Bind_Search.trim() isnt ''
			TAGT.models.Settings.upsert
				_id: 'LDAP_Custom_Domain_Search'
			,
				$set:
					value: LDAP_Bind_Search
				$setOnInsert:
					createdAt: new Date

			TAGT.models.Settings.upsert
				_id: 'LDAP_Use_Custom_Domain_Search'
			,
				$set:
					value: true
				$setOnInsert:
					createdAt: new Date


		TAGT.models.Settings.remove({_id: 'LDAP_Url'})
		TAGT.models.Settings.remove({_id: 'LDAP_TLS'})
		TAGT.models.Settings.remove({_id: 'LDAP_DN'})
		TAGT.models.Settings.remove({_id: 'LDAP_Bind_Search'})
