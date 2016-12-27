/* globals TAGT */
TAGT.authz.roomAccessValidators = [
	function(room, user) {
		return room.usernames.indexOf(user.username) !== -1;
	},
	function(room, user) {
		if (room.t === 'c') {
			return TAGT.authz.hasPermission(user._id, 'view-c-room');
		}
	}
];

TAGT.authz.canAccessRoom = function(room, user) {
	return TAGT.authz.roomAccessValidators.some((validator) => {
		return validator.call(this, room, user);
	});
};

TAGT.authz.addRoomAccessValidator = function(validator) {
	TAGT.authz.roomAccessValidators.push(validator);
};
