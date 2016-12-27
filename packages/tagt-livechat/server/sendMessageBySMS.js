TAGT.callbacks.add('afterSaveMessage', function(message, room) {
	// skips this callback if the message was edited
	if (message.editedAt) {
		return message;
	}

	if (!TAGT.SMS.enabled) {
		return message;
	}

	// only send the sms by SMS if it is a livechat room with SMS set to true
	if (!(typeof room.t !== 'undefined' && room.t === 'l' && room.sms && room.v && room.v.token)) {
		return message;
	}

	// if the message has a token, it was sent from the visitor, so ignore it
	if (message.token) {
		return message;
	}

	// if the message has a type means it is a special message (like the closing comment), so skips
	if (message.t) {
		return message;
	}

	const SMSService = TAGT.SMS.getService(TAGT.settings.get('SMS_Service'));

	if (!SMSService) {
		return message;
	}

	const visitor = TAGT.models.Users.getVisitorByToken(room.v.token);

	if (!visitor || !visitor.profile || !visitor.phone || visitor.phone.length === 0) {
		return message;
	}

	SMSService.send(room.sms.from, visitor.phone[0].phoneNumber, message.msg);

	return message;

}, TAGT.callbacks.priority.LOW, 'sendMessageBySms');
