/* globals msgStream */
function SlackBridgeImport(command, params, item) {
	var channel, room, user;
	if (command !== 'slackbridge-import' || !Match.test(params, String)) {
		return;
	}
	room = TAGT.models.Rooms.findOneById(item.rid);
	channel = room.name;
	user = Meteor.users.findOne(Meteor.userId());

	msgStream.emit(item.rid, {
		_id: Random.id(),
		rid: item.rid,
		u: { username: 'talk get' },
		ts: new Date(),
		msg: TAPi18n.__('SlackBridge_start', {
			postProcess: 'sprintf',
			sprintf: [user.username, channel]
		}, user.language)
	});

	try {
		TAGT.SlackBridge.importMessages(item.rid, error => {
			if (error) {
				msgStream.emit(item.rid, {
					_id: Random.id(),
					rid: item.rid,
					u: { username: 'talk get' },
					ts: new Date(),
					msg: TAPi18n.__('SlackBridge_error', {
						postProcess: 'sprintf',
						sprintf: [channel, error.message]
					}, user.language)
				});
			} else {
				msgStream.emit(item.rid, {
					_id: Random.id(),
					rid: item.rid,
					u: { username: 'talk get' },
					ts: new Date(),
					msg: TAPi18n.__('SlackBridge_finish', {
						postProcess: 'sprintf',
						sprintf: [channel]
					}, user.language)
				});
			}
		});
	} catch (error) {
		msgStream.emit(item.rid, {
			_id: Random.id(),
			rid: item.rid,
			u: { username: 'talk get' },
			ts: new Date(),
			msg: TAPi18n.__('SlackBridge_error', {
				postProcess: 'sprintf',
				sprintf: [channel, error.message]
			}, user.language)
		});
		throw error;
	}
	return SlackBridgeImport;
}

TAGT.slashCommands.add('slackbridge-import', SlackBridgeImport);
