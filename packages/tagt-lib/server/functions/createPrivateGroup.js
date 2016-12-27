/* globals TAGT */
TAGT.createPrivateGroup = function(name, owner, members) {
	name = s.trim(name);
	owner = s.trim(owner);
	members = [].concat(members);

	if (!name) {
		throw new Meteor.Error('error-invalid-name', 'Invalid name', { function: 'TAGT.createPrivateGroup' });
	}

	if (!owner) {
		throw new Meteor.Error('error-invalid-user', 'Invalid user', { function: 'TAGT.createPrivateGroup' });
	}

	let nameValidation;
	try {
		nameValidation = new RegExp('^' + TAGT.settings.get('UTF8_Names_Validation') + '$');
	} catch (error) {
		nameValidation = new RegExp('^[0-9a-zA-Z-_.]+$');
	}

	if (!nameValidation.test(name)) {
		throw new Meteor.Error('error-invalid-name', 'Invalid name', { function: 'TAGT.createPrivateGroup' });
	}

	let now = new Date();
	if (!_.contains(members, owner)) {
		members.push(owner);
	}

	// avoid duplicate names
	let room = TAGT.models.Rooms.findOneByName(name);
	if (room) {
		if (room.archived) {
			throw new Meteor.Error('error-archived-duplicate-name', 'There\'s an archived channel with name ' + name, { function: 'TAGT.createPrivateGroup', room_name: name });
		} else {
			throw new Meteor.Error('error-duplicate-channel-name', 'A channel with name \'' + name + '\' exists', { function: 'TAGT.createPrivateGroup', room_name: name });
		}
	}

	room = TAGT.models.Rooms.createWithTypeNameUserAndUsernames('p', name, owner, members, { ts: now });

	for (let username of members) {
		let member = TAGT.models.Users.findOneByUsername(username, { fields: { username: 1 }});
		if (!member) {
			continue;
		}

		let extra = { open: true };

		if (username === owner) {
			extra.ls = now;
		}

		TAGT.models.Subscriptions.createWithRoomAndUser(room, member, extra);
	}

	// set owner
	owner = TAGT.models.Users.findOneByUsername(owner, { fields: { username: 1 }});
	TAGT.authz.addUserRoles(owner._id, ['owner'], room._id);

	return {
		rid: room._id
	};
};
