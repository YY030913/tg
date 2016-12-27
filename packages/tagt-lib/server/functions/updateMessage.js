TAGT.updateMessage = function(message, user) {
	// If we keep history of edits, insert a new message to store history information
	if (TAGT.settings.get('Message_KeepHistory')) {
		TAGT.models.Messages.cloneAndSaveAsHistoryById(message._id);
	}

	message.editedAt = new Date();
	message.editedBy = {
		_id: user._id,
		username: user.username
	};

	let urls = message.msg.match(/([A-Za-z]{3,9}):\/\/([-;:&=\+\$,\w]+@{1})?([-A-Za-z0-9\.]+)+:?(\d+)?((\/[-\+=!:~%\/\.@\,\w]*)?\??([-\+=&!:;%@\/\.\,\w]+)?(?:#([^\s\)]+))?)?/g);
	if (urls) {
		message.urls = urls.map((url) => { return { url: url }; });
	}

	message = TAGT.callbacks.run('beforeSaveMessage', message);

	let tempid = message._id;
	delete message._id;

	TAGT.models.Messages.update({ _id: tempid }, { $set: message });

	let room = TAGT.models.Rooms.findOneById(message.rid);

	Meteor.defer(function() {
		TAGT.callbacks.run('afterSaveMessage', TAGT.models.Messages.findOneById(tempid), room);
	});
};
