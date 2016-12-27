Meteor.methods({
	'livechat:setCustomField'(token, key, value) {
		const customField = TAGT.models.LivechatCustomField.findOneById(key);
		if (customField) {
			if (customField.scope === 'room') {
				return TAGT.models.Rooms.updateLivechatDataByToken(token, key, value);
			} else {
				// Save in user
				return TAGT.models.Users.updateLivechatDataByToken(token, key, value);
			}
		}

		return true;
	}
});
