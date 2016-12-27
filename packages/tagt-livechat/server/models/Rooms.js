/**
 * Gets visitor by token
 * @param {string} token - Visitor token
 */
TAGT.models.Rooms.updateSurveyFeedbackById = function(_id, surveyFeedback) {
	const query = {
		_id: _id
	};

	const update = {
		$set: {
			surveyFeedback: surveyFeedback
		}
	};

	return this.update(query, update);
};

TAGT.models.Rooms.updateLivechatDataByToken = function(token, key, value) {
	const query = {
		'v.token': token,
		open: true
	};

	const update = {
		$set: {
			[`livechatData.${key}`]: value
		}
	};

	return this.update(query, update);
};

TAGT.models.Rooms.findLivechat = function(filter = {}, offset = 0, limit = 20) {
	const query = _.extend(filter, {
		t: 'l'
	});

	return this.find(query, { sort: { ts: - 1 }, offset: offset, limit: limit });
};

TAGT.models.Rooms.findLivechatByCode = function(code, fields) {
	const query = {
		t: 'l',
		code: parseInt(code)
	};

	let options = {};

	if (fields) {
		options.fields = fields;
	}

	return this.find(query, options);
};

/**
 * Get the next visitor name
 * @return {string} The next visitor name
 */
TAGT.models.Rooms.getNextLivechatRoomCode = function() {
	const settingsRaw = TAGT.models.Settings.model.rawCollection();
	const findAndModify = Meteor.wrapAsync(settingsRaw.findAndModify, settingsRaw);

	const query = {
		_id: 'Livechat_Room_Count'
	};

	const update = {
		$inc: {
			value: 1
		}
	};

	const livechatCount = findAndModify(query, null, update);

	return livechatCount.value.value;
};

TAGT.models.Rooms.findOpenByVisitorToken = function(visitorToken, options) {
	const query = {
		open: true,
		'v.token': visitorToken
	};

	return this.find(query, options);
};

TAGT.models.Rooms.findByVisitorToken = function(visitorToken) {
	const query = {
		'v.token': visitorToken
	};

	return this.find(query);
};

TAGT.models.Rooms.findByVisitorId = function(visitorId) {
	const query = {
		'v._id': visitorId
	};

	return this.find(query);
};

TAGT.models.Rooms.findOneOpenByVisitorId = function(visitorId) {
	const query = {
		open: true,
		'v._id': visitorId
	};

	return this.findOne(query);
};

TAGT.models.Rooms.setResponseByRoomId = function(roomId, response) {
	return this.update({
		_id: roomId
	}, {
		$set: {
			responseBy: {
				_id: response.user._id,
				username: response.user.username
			},
			responseDate: response.responseDate,
			responseTime: response.responseTime
		},
		$unset: {
			waitingResponse: 1
		}
	});
};

TAGT.models.Rooms.closeByRoomId = function(roomId, closeInfo) {
	return this.update({
		_id: roomId
	}, {
		$set: {
			closedBy: {
				_id: closeInfo.user._id,
				username: closeInfo.user.username
			},
			closedAt: closeInfo.closedAt,
			chatDuration: closeInfo.chatDuration
		},
		$unset: {
			open: 1
		}
	});
};

TAGT.models.Rooms.setLabelByRoomId = function(roomId, label) {
	return this.update({ _id: roomId }, { $set: { label: label } });
};

TAGT.models.Rooms.findOpenByAgent = function(userId) {
	const query = {
		open: true,
		'servedBy._id': userId
	};

	return this.find(query);
};

TAGT.models.Rooms.changeAgentByRoomId = function(roomId, newUsernames, newAgent) {
	const query = {
		_id: roomId
	};
	const update = {
		$set: {
			usernames: newUsernames,
			servedBy: {
				_id: newAgent.agentId,
				username: newAgent.username
			}
		}
	};

	this.update(query, update);
};

TAGT.models.Rooms.saveCRMDataByRoomId = function(roomId, crmData) {
	const query = {
		_id: roomId
	};
	const update = {
		$set: {
			crmData
		}
	};

	return this.update(query, update);
};
