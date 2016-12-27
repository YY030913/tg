TAGT.Migrations.add({
	version: 55,
	up: function() {
		TAGT.models.Rooms.find({ 'topic': { $exists: 1, $ne: '' } }, { topic: 1 }).forEach(function(room) {
			let topic = s.escapeHTML(room.topic);
			TAGT.models.Rooms.update({ _id: room._id }, { $set: { topic: topic }});
			TAGT.models.Messages.update({ t: 'room_changed_topic', rid: room._id }, { $set: { msg: topic }});
		});
	}
});
