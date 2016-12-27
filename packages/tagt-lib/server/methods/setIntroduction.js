Meteor.methods({
	setIntroduction: function(introduction) {
		if (!Meteor.userId()) {
			throw new Meteor.Error('error-invalid-user', 'Invalid user', { method: 'setIntroduction' });
		}

		const user = Meteor.user();

		if (!TAGT.settings.get('Accounts_AllowUserIntroductionChange')) {
			throw new Meteor.Error('error-action-not-allowed', 'Changing introduction is not allowed', { method: 'setIntroduction', action: 'Changing_introduction' });
		}

		if (user.introductions && user.introductions[0] && user.introductions[0].address === introduction) {
			return introduction;
		}

		if (!TAGT.setIntroduction(user._id, introduction)) {
			throw new Meteor.Error('error-could-not-change-introduction', 'Could not change introduction', { method: 'setIntroduction' });
		}

		return introduction;
	}
});

TAGT.RateLimiter.limitMethod('setIntroduction', 1, 1000, {
	userId: function(/*userId*/) { return true; }
});
