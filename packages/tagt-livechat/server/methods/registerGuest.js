Meteor.methods({
	'livechat:registerGuest': function({ token, name, email, department } = {}) {
		var stampedToken = Accounts._generateStampedLoginToken();
		var hashStampedToken = Accounts._hashStampedToken(stampedToken);

		let userId = TAGT.Livechat.registerGuest.call(this, {
			token: token,
			name: name,
			email: email,
			department: department,
			loginToken: hashStampedToken
		});

		// update visited page history to not expire
		TAGT.models.LivechatPageVisited.keepHistoryForToken(token);

		return {
			userId: userId,
			token: stampedToken.token
		};
	}
});
