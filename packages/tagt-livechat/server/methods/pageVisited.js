Meteor.methods({
	'livechat:pageVisited'(token, pageInfo) {
		return TAGT.Livechat.savePageHistory(token, pageInfo);
	}
});
