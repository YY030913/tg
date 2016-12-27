Meteor.methods({
	updateOTRAck: function(_id, ack) {
		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'updateOTRAck' });
		}
		TAGT.models.Messages.updateOTRAck(_id, ack);
	}
});
