Meteor.methods
	readMessages: (rid) ->

		check rid, String

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'readMessages' }

		TAGT.models.Subscriptions.setAsReadByRoomIdAndUserId rid, Meteor.userId()
