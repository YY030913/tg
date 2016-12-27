TAGT.models.Messages.setReactions = function(messageId, reactions) {
	return this.update({ _id: messageId }, { $set: { reactions: reactions }});
};

TAGT.models.Messages.unsetReactions = function(messageId) {
	return this.update({ _id: messageId }, { $unset: { reactions: 1 }});
};
