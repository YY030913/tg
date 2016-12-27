function sendToCRM(hook, room) {
	if (!TAGT.settings.get('Livechat_webhook_on_close')) {
		return room;
	}

	let postData = TAGT.Livechat.getLivechatRoomGuestInfo(room);
	if (hook === 'closeRoom') {
		postData.type = 'LivechatSession';
	} else if (hook === 'saveLivechatInfo') {
		postData.type = 'LivechatEdit';
	}

	postData.messages = [];

	TAGT.models.Messages.findVisibleByRoomId(room._id, { sort: { ts: 1 } }).forEach((message) => {
		if (message.t) {
			return;
		}
		let msg = {
			username: message.u.username,
			msg: message.msg,
			ts: message.ts
		};

		if (message.u.username !== postData.visitor.username) {
			msg.agentId = message.u._id;
		}
		postData.messages.push(msg);
	});

	const response = TAGT.Livechat.sendRequest(postData);

	if (response && response.data && response.data.data) {
		TAGT.models.Rooms.saveCRMDataByRoomId(room._id, response.data.data);
	}

	return room;
}

TAGT.callbacks.add('livechat.closeRoom', (room) => {
	return sendToCRM('closeRoom', room);
});

TAGT.callbacks.add('livechat.saveInfo', (room) => {
	return sendToCRM('saveLivechatInfo', room);
});
