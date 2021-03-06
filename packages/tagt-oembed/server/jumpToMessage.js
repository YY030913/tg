/* globals getAvatarUrlFromUsername */

const URL = Npm.require('url');
const QueryString = Npm.require('querystring');

TAGT.callbacks.add('beforeSaveMessage', (msg) => {
	if (msg && msg.urls) {
		msg.urls.forEach((item) => {
			if (item.url.indexOf(Meteor.absoluteUrl()) === 0) {
				const urlObj = URL.parse(item.url);
				if (urlObj.query) {
					const queryString = QueryString.parse(urlObj.query);
					if (_.isString(queryString.msg)) { // Jump-to query param
						let jumpToMessage = TAGT.models.Messages.findOneById(queryString.msg);
						if (jumpToMessage) {
							msg.attachments = msg.attachments || [];
							msg.attachments.push({
								'text' : jumpToMessage.msg,
								'author_name' : jumpToMessage.u.username,
								'author_icon' : getAvatarUrlFromUsername(jumpToMessage.u.username),
								'message_link' : item.url,
								'ts': jumpToMessage.ts
							});
							item.ignoreParse = true;
						}
					}
				}
			}
		});
	}
	return msg;
}, TAGT.callbacks.priority.LOW);
