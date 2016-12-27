
Meteor.methods({
	'jitsi:updateTimeout': (rid) => {
		let room = TAGT.models.Rooms.findOne({_id: rid});
		let currentTime = new Date().getTime();

		let jitsiTimeout = new Date((room && room.jitsiTimeout) || currentTime).getTime();

		if (jitsiTimeout <= currentTime) {
			TAGT.models.Rooms.setJitsiTimeout(rid, new Date(currentTime + 35*1000));
			TAGT.models.Messages.createWithTypeRoomIdMessageAndUser('jitsi_call_started', rid, '', Meteor.user(), {
				actionLinks : [
					{ icon: 'icon-videocam', label: 'Click To Join!', method_id: 'joinJitsiCall', params: ''}
				]
			});
		} else if ((jitsiTimeout - currentTime) / 1000 <= 15) {
			TAGT.models.Rooms.setJitsiTimeout(rid, new Date(jitsiTimeout + 25*1000));
		}
	}
});
