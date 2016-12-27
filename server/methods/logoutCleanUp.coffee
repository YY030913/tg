Meteor.methods
	logoutCleanUp: (user) ->

		check user, Object

		Meteor.defer ->

			TAGT.callbacks.run 'afterLogoutCleanUp', user
