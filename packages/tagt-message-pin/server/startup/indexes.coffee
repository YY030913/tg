Meteor.startup ->
	Meteor.defer ->
		TAGT.models.Messages.tryEnsureIndex { 'pinnedBy._id': 1 }, { sparse: 1 }
