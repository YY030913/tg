Meteor.startup ->
	TAGT.settings.add 'Message_AllowPinning', true, { type: 'boolean', group: 'Message', public: true }
	TAGT.models.Permissions.upsert('pin-message', { $setOnInsert: { roles: ['owner', 'moderator', 'admin'] } });
