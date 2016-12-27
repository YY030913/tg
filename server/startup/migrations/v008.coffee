TAGT.Migrations.add
	version: 8
	up: ->
		console.log 'Load old settings record'
		settings = TAGT.models.Settings.findOne({ _id: 'settings' })
		if settings
			TAGT.models.Settings.insert { _id: 'CDN_PREFIX', value: settings.CDN_PREFIX, type: 'string', group: 'General' } if settings.CDN_PREFIX?
			TAGT.models.Settings.insert { _id: 'MAIL_URL', value: settings.ENV.MAIL_URL, type: 'string', group: 'SMTP' } if settings.ENV?.MAIL_URL?
			TAGT.models.Settings.insert { _id: 'Accounts_denyUnverifiedEmails', value: settings.denyUnverifiedEmails, type: 'boolean', group: 'Accounts' } if settings.denyUnverifiedEmails?
			TAGT.models.Settings.insert { _id: 'avatarStore_type', value: settings.public.avatarStore.type, type: 'string', group: 'API' } if settings.public?.avatarStore?.type?
			TAGT.models.Settings.insert { _id: 'avatarStore_path', value: settings.public.avatarStore.path, type: 'string', group: 'API' } if settings.public?.avatarStore?.path?
			TAGT.models.Settings.remove { _id: 'settings' }
