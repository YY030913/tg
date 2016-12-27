Meteor.methods
	checkRegistrationSecretURL: (hash) ->

		check hash, String

		return hash is TAGT.settings.get 'Accounts_RegistrationForm_SecretURL'
