/* globals deleteEmojiCustom */
Meteor.startup(() =>
	TAGT.Notifications.onAll('deleteEmojiCustom', data => deleteEmojiCustom(data.emojiData))
);
