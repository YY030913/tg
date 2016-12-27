Meteor.startup ->
	TAGT.Notifications.onAll 'updateAvatar', (data) ->
		updateAvatarOfUsername data.username
