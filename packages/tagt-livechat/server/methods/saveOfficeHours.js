Meteor.methods({
	'livechat:saveOfficeHours'(day, start, finish, open) {
		TAGT.models.LivechatOfficeHour.updateHours(day, start, finish, open);
	}
});