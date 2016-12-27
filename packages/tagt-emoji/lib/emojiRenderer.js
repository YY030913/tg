/* globals HTML, isSetNotNull, renderEmoji:true */
renderEmoji = function(emoji) {
	if (isSetNotNull(() => TAGT.emoji.list[emoji].emojiPackage)) {
		let emojiPackage = TAGT.emoji.list[emoji].emojiPackage;
		return TAGT.emoji.packages[emojiPackage].render(emoji);
	}
};

Blaze.registerHelper('renderEmoji', renderEmoji);

Template.registerHelper('renderEmoji', new Template('renderEmoji', function() {
	let view = this;
	let emoji = Blaze.getData(view);

	if (isSetNotNull(() => TAGT.emoji.list[emoji].emojiPackage)) {
		let emojiPackage = TAGT.emoji.list[emoji].emojiPackage;
		return new HTML.Raw(TAGT.emoji.packages[emojiPackage].render(emoji));
	}

	return '';
}));

/* exported renderEmoji */
