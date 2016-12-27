Meteor.startup ->
	permission = { _id: 'mail-messages', roles : [ 'admin' ] }
	TAGT.models.Permissions.upsert( permission._id, { $setOnInsert : permission })
