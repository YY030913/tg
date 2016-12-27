Meteor.startup ->
	TAGT.models.Permissions.upsert( 'access-mailer', { $setOnInsert : { _id: 'access-mailer', roles : ['admin'] } })
