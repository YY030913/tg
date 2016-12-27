/* globals FileUpload */
TAGT.deleteMessage = function(message, user) {
	let keepHistory = TAGT.settings.get('Message_KeepHistory');
	let showDeletedStatus = TAGT.settings.get('Message_ShowDeletedStatus');

	if (keepHistory) {
		if (showDeletedStatus) {
			TAGT.models.Messages.cloneAndSaveAsHistoryById(message._id);
		} else {
			TAGT.models.Messages.setHiddenById(message._id, true);
		}

		if (message.file && message.file._id) {
			TAGT.models.Uploads.update(message.file._id, { $set: { _hidden: true } });
		}
	} else {
		if (!showDeletedStatus) {
			TAGT.models.Messages.removeById(message._id);
		}

		if (message.file && message.file._id) {
			FileUpload.delete(message.file._id);
		}
	}

	if (showDeletedStatus) {
		TAGT.models.Messages.setAsDeletedByIdAndUser(message._id, user);
	} else {
		TAGT.Notifications.notifyRoom(message.rid, 'deleteMessage', { _id: message._id });
	}
};
