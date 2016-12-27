Meteor.methods
	migrateTo: (version) ->

		check version, String

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'migrateTo' }

		user = Meteor.user()

		if not user? or TAGT.authz.hasPermission(user._id, 'run-migration') isnt true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'migrateTo' }

		this.unblock()
		TAGT.Migrations.migrateTo version
		return version

	getMigrationVersion: ->
		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'getMigrationVersion' }

		return TAGT.Migrations.getVersion()
