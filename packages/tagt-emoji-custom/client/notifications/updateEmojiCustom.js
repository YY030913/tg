/* globals updateEmojiCustom */
Meteor.startup(() =>
	TAGT.Notifications.onAll('updateEmojiCustom', data => updateEmojiCustom(data.emojiData))
);
