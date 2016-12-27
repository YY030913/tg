Meteor.startup(function() {
	TAGT.models.Permissions.upsert('post-readonly', {$set: { roles: ['admin', 'owner', 'moderator'] } });
	TAGT.models.Permissions.upsert('set-readonly', {$set: { roles: ['admin', 'owner'] } });
});
