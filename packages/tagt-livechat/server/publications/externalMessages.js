Meteor.publish('livechat:externalMessages', function(roomId) {
	return TAGT.models.LivechatExternalMessage.findByRoomId(roomId);
});
