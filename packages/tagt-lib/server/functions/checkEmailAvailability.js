TAGT.checkEmailAvailability = function(email) {
	return !Meteor.users.findOne({ 'emails.address': { $regex : new RegExp('^' + s.trim(s.escapeRegExp(email)) + '$', 'i') } });
};
