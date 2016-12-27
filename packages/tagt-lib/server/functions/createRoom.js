/* globals TAGT */
TAGT.createRoom = function(type, name, owner, members, readOnly) {
	name = s.trim(name);
	owner = s.trim(owner);
	members = [].concat(members);

	if (!name) {
		throw new Meteor.Error('error-invalid-name', 'Invalid name', { function: 'TAGT.createRoom' });
	}

	owner = TAGT.models.Users.findOneByUsername(owner, { fields: { username: 1 }});
	if (!owner) {
		throw new Meteor.Error('error-invalid-user', 'Invalid user', { function: 'TAGT.createRoom' });
	}

	let nameValidation;
	try {
		nameValidation = new RegExp('^' + TAGT.settings.get('UTF8_Names_Validation') + '$');
	} catch (error) {
		nameValidation = new RegExp('^[0-9a-zA-Z-_.]+$');
	}

	if (!nameValidation.test(name)) {
		throw new Meteor.Error('error-invalid-name', 'Invalid name', { function: 'TAGT.createRoom' });
	}

	let now = new Date();
	if (!_.contains(members, owner.username)) {
		members.push(owner.username);
	}

	// avoid duplicate names
	let room = TAGT.models.Rooms.findOneByName(name);
	if (room) {
		if (room.archived) {
			throw new Meteor.Error('error-archived-duplicate-name', 'There\'s an archived channel with name ' + name, { function: 'TAGT.createRoom', room_name: name });
		} else {
			throw new Meteor.Error('error-duplicate-channel-name', 'A channel with name \'' + name + '\' exists', { function: 'TAGT.createRoom', room_name: name });
		}
	}

	if (type === 'c') {
		TAGT.callbacks.run('beforeCreateChannel', owner, {
			t: 'c',
			name: name,
			ts: now,
			ro: readOnly === true,
			sysMes: readOnly !== true,
			usernames: members,
			u: {
				_id: owner._id,
				username: owner.username
			}
		});
	}

	room = TAGT.models.Rooms.createWithTypeNameUserAndUsernames(type, name, owner.username, members, {
		ts: now,
		ro: readOnly === true,
		sysMes: readOnly !== true
	});

	for (let username of members) {
		let member = TAGT.models.Users.findOneByUsername(username, { fields: { username: 1 }});
		if (!member) {
			continue;
		}

		// make all room members muted by default, unless they have the post-readonly permission
		if (readOnly === true && !TAGT.authz.hasPermission(member._id, 'post-readonly')) {
			TAGT.models.Rooms.muteUsernameByRoomId(room._id, username);
		}

		let extra = { open: true };

		if (username === owner.username) {
			extra.ls = now;
		}

		TAGT.models.Subscriptions.createWithRoomAndUser(room, member, extra);
	}

	TAGT.authz.addUserRoles(owner._id, ['owner'], room._id);

	if (type === 'c') {
		Meteor.defer(() => {
			TAGT.callbacks.run('afterCreateChannel', owner, room);
		});
	}

	return {
		rid: room._id
	};
};
