TAGT.callbacks.add('afterSaveMessage', function(message, room) {
	// skips this callback if the message was edited
	if (message.editedAt) {
		return message;
	}

	if (message.ts && Math.abs(moment(message.ts).diff()) > 60000) {
		return message;
	}

	var emailSubject, usersToSendEmail = {};
	var directMessage = room.t === 'd';

	if (directMessage) {
		usersToSendEmail[message.rid.replace(message.u._id, '')] = 1;

		emailSubject = TAPi18n.__('Offline_DM_Email', {
			user: message.u.username
		});

	} else {
		if (message.mentions) {
			message.mentions.forEach(function(mention) {
				usersToSendEmail[mention._id] = 1;
			});
		}

		emailSubject = TAPi18n.__('Offline_Mention_Email', {
			user: message.u.username,
			room: room.name
		});
	}

	var getMessageLink = (room, sub) => {
		var roomPath = TAGT.roomTypes.getRouteLink(room.t, sub);
		var path = Meteor.absoluteUrl(roomPath ? roomPath.replace(/^\//, '') : '');
		var style = [
			'color: #fff;',
			'padding: 9px 12px;',
			'border-radius: 4px;',
			'background-color: #04436a;',
			'text-decoration: none;'
		].join(' ');
		var message = TAPi18n.__('Offline_Link_Message');
		return `<p style="text-align:center;margin-bottom:8px;"><a style="${ style }" href="${ path }">${ message }</a>`;
	};

	var divisorMessage = '<hr style="margin: 20px auto; border: none; border-bottom: 1px solid #dddddd;">';
	var messageHTML = s.escapeHTML(message.msg);

	message = TAGT.callbacks.run('renderMessage', message);
	if (message.tokens && message.tokens.length > 0) {
		message.tokens.forEach((token) => {
			token.text = token.text.replace(/([^\$])(\$[^\$])/gm, '$1$$$2');
			messageHTML = messageHTML.replace(token.token, token.text);
		});
	}

	var header = TAGT.placeholders.replace(TAGT.settings.get('Email_Header') || '');
	var footer = TAGT.placeholders.replace(TAGT.settings.get('Email_Footer') || '');
	messageHTML = messageHTML.replace(/\n/gm, '<br/>');

	TAGT.models.Subscriptions.findWithSendEmailByRoomId(room._id).forEach((sub) => {
		switch (sub.emailNotifications) {
			case 'all':
				usersToSendEmail[sub.u._id] = 'force';
				break;
			case 'mentions':
				if (usersToSendEmail[sub.u._id]) {
					usersToSendEmail[sub.u._id] = 'force';
				}
				break;
			case 'nothing':
				delete usersToSendEmail[sub.u._id];
				break;
			case 'default':
				break;
		}
	});

	var userIdsToSendEmail = Object.keys(usersToSendEmail);

	var defaultLink;

	var linkByUser = {};
	if (TAGT.roomTypes.hasCustomLink(room.t)) {
		TAGT.models.Subscriptions.findByRoomIdAndUserIds(room._id, userIdsToSendEmail).forEach((sub) => {
			linkByUser[sub.u._id] = getMessageLink(room, sub);
		});
	} else {
		defaultLink = getMessageLink(room, { name: room.name });
	}

	if (userIdsToSendEmail.length > 0) {
		var usersOfMention = TAGT.models.Users.getUsersToSendOfflineEmail(userIdsToSendEmail).fetch();

		if (usersOfMention && usersOfMention.length > 0) {
			var siteName = TAGT.settings.get('Site_Name');

			usersOfMention.forEach((user) => {
				if (user.settings && user.settings.preferences && user.settings.preferences.emailNotificationMode && user.settings.preferences.emailNotificationMode === 'disabled' && usersToSendEmail[user._id] !== 'force') {
					return;
				}

				// Checks if user is in the room he/she is mentioned (unless it's public channel)
				if (room.t !== 'c' && room.usernames.indexOf(user.username) === -1) {
					return;
				}

				user.emails.some((email) => {
					if (email.verified) {
						email = {
							to: email.address,
							from: TAGT.settings.get('From_Email'),
							subject: `[${ siteName }] ${ emailSubject }`,
							html: header + messageHTML + divisorMessage + (linkByUser[user._id] || defaultLink) + footer
						};

						Meteor.defer(() => {
							Email.send(email);
						});

						return true;
					}
				});
			});
		}
	}

	return message;

}, TAGT.callbacks.priority.LOW, 'sendEmailOnMessage');
