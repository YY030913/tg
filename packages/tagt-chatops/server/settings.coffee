Meteor.startup ->
	TAGT.settings.addGroup 'Chatops'
	TAGT.settings.add 'Chatops_Enabled', false, { type: 'boolean', group: 'Chatops', public: true }
	TAGT.settings.add 'Chatops_Username', false, { type: 'string', group: 'Chatops', public: true }
