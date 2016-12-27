/* globals emojione, emojisByCategory, emojiCategories, toneList */
TAGT.emoji.packages.emojione = emojione;
TAGT.emoji.packages.emojione.imageType = 'png';
TAGT.emoji.packages.emojione.sprites = true;
TAGT.emoji.packages.emojione.emojisByCategory = emojisByCategory;
TAGT.emoji.packages.emojione.emojiCategories = emojiCategories;
TAGT.emoji.packages.emojione.toneList = toneList;

TAGT.emoji.packages.emojione.render = function(emoji) {
	return emojione.toImage(emoji);
};

//http://stackoverflow.com/a/26990347 function isSet() from Gajus
function isSetNotNull(fn) {
	var value;
	try {
		value = fn();
	} catch (e) {
		value = null;
	} finally {
		return value !== null && value !== undefined;
	}
}

// TAGT.emoji.list is the collection of emojis from all emoji packages
for (let key in emojione.emojioneList) {
	if (emojione.emojioneList.hasOwnProperty(key)) {
		let emoji = emojione.emojioneList[key];
		emoji.emojiPackage = 'emojione';
		TAGT.emoji.list[key] = emoji;
	}
}

// Additional settings -- ascii emojis
Meteor.startup(function() {
	Tracker.autorun(function() {
		if (isSetNotNull(() => TAGT.emoji.packages.emojione)) {
			if (isSetNotNull(() => Meteor.user().settings.preferences.convertAsciiEmoji)) {
				TAGT.emoji.packages.emojione.ascii = Meteor.user().settings.preferences.convertAsciiEmoji;
			} else {
				TAGT.emoji.packages.emojione.ascii = true;
			}
		}
	});
});
