/* globals isSetNotNull, TAGTFileEmojiCustomInstance */
Meteor.methods({
	deleteEmojiCustom(emojiID) {
		let emoji = null;

		if (TAGT.authz.hasPermission(this.userId, 'manage-emoji')) {
			emoji = TAGT.models.EmojiCustom.findOneByID(emojiID);
		} else {
			throw new Meteor.Error('not_authorized');
		}

		if (!isSetNotNull(() => emoji)) {
			throw new Meteor.Error('Custom_Emoji_Error_Invalid_Emoji', 'Invalid emoji', { method: 'deleteEmojiCustom' });
		}

		TAGTFileEmojiCustomInstance.deleteFile(encodeURIComponent(`${emoji.name}.${emoji.extension}`));
		TAGT.models.EmojiCustom.removeByID(emojiID);
		TAGT.Notifications.notifyAll('deleteEmojiCustom', {emojiData: emoji});

		return true;
	}
});
