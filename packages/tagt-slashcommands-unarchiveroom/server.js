function Unarchive(command, params, item) {
	var channel, room, user;
	if (command !== 'unarchive' || !Match.test(params, String)) {
		return;
	}
	channel = params.trim();
	if (channel === '') {
		room = TAGT.models.Rooms.findOneById(item.rid);
		channel = room.name;
	} else {
		channel = channel.replace('#', '');
		room = TAGT.models.Rooms.findOneByName(channel);
	}
	user = Meteor.users.findOne(Meteor.userId());

	if (!room.archived) {
		TAGT.Notifications.notifyUser(Meteor.userId(), 'message', {
			_id: Random.id(),
			rid: item.rid,
			ts: new Date(),
			msg: TAPi18n.__('Channel_already_Unarchived', {
				postProcess: 'sprintf',
				sprintf: [channel]
			}, user.language)
		});
		return;
	}
	Meteor.call('unarchiveRoom', room._id);
	TAGT.models.Messages.createRoomUnarchivedByRoomIdAndUser(room._id, Meteor.user());
	TAGT.Notifications.notifyUser(Meteor.userId(), 'message', {
		_id: Random.id(),
		rid: item.rid,
		ts: new Date(),
		msg: TAPi18n.__('Channel_Unarchived', {
			postProcess: 'sprintf',
			sprintf: [channel]
		}, user.language)
	});
	return Unarchive;
}

TAGT.slashCommands.add('unarchive', Unarchive);
