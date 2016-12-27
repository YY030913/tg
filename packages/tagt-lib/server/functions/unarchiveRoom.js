TAGT.unarchiveRoom = function(rid) {
	TAGT.models.Rooms.unarchiveById(rid);
	TAGT.models.Subscriptions.unarchiveByRoomId(rid);
};
