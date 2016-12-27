function Archive(command, params, item) {
	var channel, room, user;
	if (command !== 'archive' || !Match.test(params, String)) {
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

	if (room.archived) {
		TAGT.Notifications.notifyUser(Meteor.userId(), 'message', {
			_id: Random.id(),
			rid: item.rid,
			ts: new Date(),
			msg: TAPi18n.__('Duplicate_archived_channel_name', {
				postProcess: 'sprintf',
				sprintf: [channel]
			}, user.language)
		});
		return;
	}
	Meteor.call('archiveRoom', room._id);

	TAGT.models.Messages.createRoomArchivedByRoomIdAndUser(room._id, Meteor.user());
	TAGT.Notifications.notifyUser(Meteor.userId(), 'message', {
		_id: Random.id(),
		rid: item.rid,
		ts: new Date(),
		msg: TAPi18n.__('Channel_Archived', {
			postProcess: 'sprintf',
			sprintf: [channel]
		}, user.language)
	});

	return Archive;
}

TAGT.slashCommands.add('archive', Archive);
