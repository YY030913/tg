Meteor.startup(function() {
	Tracker.autorun(function() {
		var user = Meteor.user();
		if (user && user.emails && user.emails[0] && user.emails[0].verified !== true && TAGT.settings.get('Accounts_EmailVerification') === true && !Session.get('Accounts_EmailVerification_Warning')) {
			toastr.warning(TAPi18n.__('You_have_not_verified_your_email'));
			Session.set('Accounts_EmailVerification_Warning', true);
		}
	});
});
