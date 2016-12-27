/* globals TAGTFileEmojiCustomInstance */
Meteor.methods({
	uploadEmojiCustom(binaryContent, contentType, emojiData) {
		if (!TAGT.authz.hasPermission(this.userId, 'manage-emoji')) {
			throw new Meteor.Error('not_authorized');
		}

		//delete aliases for notification purposes. here, it is a string rather than an array
		delete emojiData.aliases;
		let file = new Buffer(binaryContent, 'binary');

		let rs = TAGTFile.bufferToStream(file);
		TAGTFileEmojiCustomInstance.deleteFile(encodeURIComponent(`${emojiData.name}.${emojiData.extension}`));
		let ws = TAGTFileEmojiCustomInstance.createWriteStream(encodeURIComponent(`${emojiData.name}.${emojiData.extension}`), contentType);
		ws.on('end', Meteor.bindEnvironment(() =>
			Meteor.setTimeout(() => TAGT.Notifications.notifyAll('updateEmojiCustom', {emojiData})
			, 500)
		));

		rs.pipe(ws);
	}
});
