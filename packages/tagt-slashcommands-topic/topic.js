/*
 * Join is a named function that will replace /topic commands
 * @param {Object} message - The message object
 */

function Topic(command, params, item) {
	if (command === 'topic') {
		if (Meteor.isClient && TAGT.authz.hasAtLeastOnePermission('edit-room', item.rid) || (Meteor.isServer && TAGT.authz.hasPermission(Meteor.userId(), 'edit-room', item.rid))) {
			Meteor.call('saveRoomSettings', item.rid, 'roomTopic', params, (err) => {
				if (err) {
					if (Meteor.isClient) {
						return handleError(err);
					} else {
						throw err;
					}
				}

				if (Meteor.isClient) {
					TAGT.callbacks.run('roomTopicChanged', ChatRoom.findOne(item.rid));
				}
			});
		}
	}
}

TAGT.slashCommands.add('topic', Topic, {
	description: 'Slash_Topic_Description',
	params: 'Slash_Topic_Params'
});
