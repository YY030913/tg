//Action Links Handler. This method will be called off the client.

Meteor.methods({
	actionLinkHandler(name, messageId) {
		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'actionLinkHandler' });
		}

		var message = TAGT.models.Messages.findOne({ _id: messageId });
		if (!message) {
			throw new Meteor.Error('error-invalid-message', 'Invalid message', { method: 'actionLinkHandler' });
		}

		var actionLink = message.actionLinks[name];
		if (!message.actionLinks || !actionLink || !TAGT.actionLinks || !TAGT.actionLinks[actionLink.method_id]) {
			throw new Meteor.Error('error-invalid-actionlink', 'Invalid action link', { method: 'actionLinkHandler' });
		}

		var room = TAGT.models.Rooms.findOne({ _id: message.rid });
		if (Array.isArray(room.usernames) && room.usernames.indexOf(Meteor.user().username) === -1) {
			throw new Meteor.Error('error-not-allowed', 'Not allowed', { method: 'actionLinkHandler' });
		}

		TAGT.actionLinks[actionLink.method_id](message, actionLink.params);
	}
});
