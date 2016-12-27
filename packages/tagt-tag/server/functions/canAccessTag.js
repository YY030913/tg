/* globals TAGT */
TAGT.authz.tagAccessValidators = [
	function(tag, user) {
		return (TAGT.models.Tags.findOneByMemeberAndTag(user, tag) != null);
	},
	function(tag, user) {
		if (tag.t === 'o') {
			return TAGT.authz.hasPermission(user._id, 'view-o-tag');
		}
	}
];

TAGT.authz.canAccessTag = function(tag, user) {
	return TAGT.authz.tagAccessValidators.some((validator) => {
		return validator.call(this, tag, user);
	});
};

TAGT.authz.addTagAccessValidator = function(validator) {
	TAGT.authz.tagAccessValidators.push(validator);
};
