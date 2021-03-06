function Create(command, params, item) {
	var channel, room, user;
	if (command !== 'create' || !Match.test(params, String)) {
		return;
	}
	channel = params.trim();
	if (channel === '') {
		return;
	}

	user = Meteor.users.findOne(Meteor.userId());
	room = TAGT.models.Rooms.findOneByName(channel);
	if (room != null) {
		TAGT.Notifications.notifyUser(Meteor.userId(), 'message', {
			_id: Random.id(),
			rid: item.rid,
			ts: new Date(),
			msg: TAPi18n.__('Channel_already_exist', {
				postProcess: 'sprintf',
				sprintf: [channel]
			}, user.language)
		});
		return;
	}
	Meteor.call('createChannel', channel, []);
}

TAGT.slashCommands.add('create', Create);
