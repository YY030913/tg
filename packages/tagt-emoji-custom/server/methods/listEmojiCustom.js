Meteor.methods({
	listEmojiCustom() {
		return TAGT.models.EmojiCustom.find({}).fetch();
	}
});
