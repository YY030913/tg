// Every minute check if office closed
Meteor.setInterval(function() {
	if (TAGT.settings.get('Livechat_enable_office_hours')) {
		if (TAGT.models.LivechatOfficeHour.isOpeningTime()) {
			TAGT.models.Users.openOffice();
		} else if (TAGT.models.LivechatOfficeHour.isClosingTime()) {
			TAGT.models.Users.closeOffice();
		}
	}
}, 60000);