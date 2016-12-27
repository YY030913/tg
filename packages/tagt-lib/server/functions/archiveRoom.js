TAGT.archiveRoom = function(rid) {
	TAGT.models.Rooms.archiveById(rid);
	TAGT.models.Subscriptions.archiveByRoomId(rid);
};
