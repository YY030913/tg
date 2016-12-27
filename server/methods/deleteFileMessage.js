Meteor.methods({
	deleteFileMessage: function(fileID) {
		check(fileID, String);

		return Meteor.call('deleteMessage', TAGT.models.Messages.getMessageByFileId(fileID));
	}
});
