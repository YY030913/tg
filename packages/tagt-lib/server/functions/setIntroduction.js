TAGT.setIntroduction = function(userId, introduction) {
	introduction = s.trim(introduction);
	if (!userId) {
		throw new Meteor.Error('error-invalid-user', 'Invalid user', { function: 'setIntroduction' });
	}

	if (!introduction) {
		throw new Meteor.Error('error-invalid-introduction', 'Invalid introduction', { function: 'setIntroduction' });
	}


	const user = TAGT.models.Users.findOneById(userId);

	// User already has desired username, return
	if (user.introductions && user.introductions === introduction) {
		return user;
	}

	// Check introduction availability
	if (!TAGT.checkIntroductionAvailability(introduction)) {
		throw new Meteor.Error('error-invalid-name-length', introduction, { function: 'setIntroduction', name: introduction, min_length: TAGT.settings.get('UTF8_Long_Names_And_Introduction_MinLength'), max_length: TAGT.settings.get('UTF8_Long_Names_And_Introduction_MaxLength')});
	}

	// Set new introduction
	TAGT.models.Users.setintroduction(user._id, introduction);
	user.introduction = introduction;
	return user;
};

TAGT.setintroduction = TAGT.RateLimiter.limitFunction(TAGT.setIntroduction, 1, 60000, {
	0: function() { return !Meteor.userId() || !TAGT.authz.hasPermission(Meteor.userId(), 'edit-other-user-info'); } // Administrators have permission to change others introductions, so don't limit those
});
