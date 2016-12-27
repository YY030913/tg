Meteor.methods
	removeOAuthService: (name) ->

		check name, String

		if not Meteor.userId()
			throw new Meteor.Error('error-invalid-user', "Invalid user", { method: 'removeOAuthService' })

		unless TAGT.authz.hasPermission( Meteor.userId(), 'add-oauth-service') is true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'removeOAuthService' }

		name = name.toLowerCase().replace(/[^a-z0-9]/g, '')
		name = s.capitalize(name)
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_url"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_token_path"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_identity_path"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_authorize_path"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_scope"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_token_sent_via"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_id"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_secret"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_button_label_text"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_button_label_color"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_button_color"
		TAGT.settings.removeById "Accounts_OAuth_Custom_#{name}_login_style"
