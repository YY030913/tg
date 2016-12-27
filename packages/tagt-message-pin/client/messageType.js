Meteor.startup(function() {
	TAGT.MessageTypes.registerType({
		id: 'message_pinned',
		system: true,
		message: 'Pinned_a_message'
	});
});
