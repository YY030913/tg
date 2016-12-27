Meteor.methods({
	'livechat:getCustomFields'() {
		return TAGT.models.LivechatCustomField.find().fetch();
	}
});
