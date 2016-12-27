Meteor.startup(function() {
	TAGT.models.Rooms.tryEnsureIndex({ code: 1 });
	TAGT.models.Rooms.tryEnsureIndex({ open: 1 }, { sparse: 1 });
});
