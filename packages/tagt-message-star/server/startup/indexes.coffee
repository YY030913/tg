Meteor.startup ->
	Meteor.defer ->
		TAGT.models.Messages.tryEnsureIndex { 'starred._id': 1 }, { sparse: 1 }
