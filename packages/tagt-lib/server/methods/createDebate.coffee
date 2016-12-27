Meteor.methods
	createDebate: (temp) ->
		_id = temp._id
		name = temp.name
		content = temp.content
		members = temp.members || []
		save = temp.save

		if !name? && !content? && _id?
			return;

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createDebate' }

		if TAGT.authz.hasPermission(Meteor.userId(), 'create-debate') isnt true
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'createDebate' }

		if temp.debateType?
			if TAGT.models.Settings.findOne('User_Rule_Enabled') is true && TAGT.rule.allowCreateDebate(Meteor.userId(), temp.debateType)
				throw new Meteor.Error 'error-rule-not-allowed', "Not allowed", { method: 'createDebate' }
		else
			if TAGT.models.Settings.findOne('User_Rule_Enabled') is true && TAGT.rule.allowCreateDebate(Meteor.userId())
				throw new Meteor.Error 'error-rule-not-allowed', "Not allowed", { method: 'createDebate' }

		if name?
			exist = TAGT.models.Debates.findOneByName(name, {_id: {$ne: _id}})
			if exist?
				throw new Meteor.Error 'error-duplicate-debate-name', "A debate with name '" + name + "' exists", {function: 'createDebate', debate_name: name}

		now = new Date()
		user = Meteor.user()
		members.push user.username if user.username not in members

		option = {
			name: 1
		}

		# avoid duplicate names
		
		debate = 
			ts: now
			usernames: members
			u:
				_id: user._id
				username: user.username
			tags: []

		if !save?
			save = false

		if save is true
			debate.save = save
		else
			if !TAGT.models.Debates.findOneByName(name, {_id: {$ne: _id}})?
				debate.save = save

		if temp.debateType?
			debate.debateType = temp.debateType

		if temp.imgs?
			debate.imgs = temp.imgs


		if name?
			debate.name = name
		if content?
			debate.htmlBody = content

		TAGT.callbacks.run 'beforeCreateDebate', debate

		record = {}
		try
			if _id?
				temp = TAGT.models.Debates.findOneBySlug _id
				if temp?
					debate._id = _id
					if name?
						if save is true
							view = TAGT.models.Debates.findOneByName name, {_id: {$ne: _id}}

							if !view?
								if !temp?.rid?
									# create new room
								
									if not Meteor.userId()
										throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'createChannel' }

									try
										nameValidation = new RegExp '^' + TAGT.settings.get('UTF8_Names_Validation') + '$'
									catch
										nameValidation = new RegExp '^[0-9a-zA-Z-_.]+$'

									if name.length > TAGT.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') || name.length < TAGT.settings.get('UTF8_Long_Names_And_Introduction_MinLength')
										throw new Meteor.Error 'error-invalid-name-length', TAPi18n.__ "Invalid name name length must in #{TAGT.settings.get('UTF8_Long_Names_And_Introduction_MinLength')} , #{TAGT.settings.get('UTF8_Long_Names_And_Introduction_MaxLength')}", { function: 'createChannel', name: name, min_length: TAGT.settings.get('UTF8_Long_Names_And_Introduction_MinLength'), max_length: TAGT.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') }

									if TAGT.authz.hasPermission(Meteor.userId(), 'create-c') isnt true
										throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'createChannel' }

									now = new Date()
									user = Meteor.user()

									members.push user.username if user.username not in members

									# avoid duplicate names
									if TAGT.models.Rooms.findOneByName name
										if TAGT.models.Rooms.findOneByName(name).archived
											throw new Meteor.Error 'error-archived-duplicate-name', "There's an archived channel with name " + name, { method: 'createChannel', room_name: name }
										else
											throw new Meteor.Error 'error-duplicate-channel-name', "A channel with name '" + name + "' exists", { function: 'createChannel', channel_name: name }

									# name = s.slugify name

									TAGT.callbacks.run 'beforeCreateChannel', user,
										t: 'c'
										name: name
										ts: now
										usernames: members
										u:
											_id: user._id
											username: user.username

									# create new room
									room = TAGT.models.Rooms.createWithTypeNameUserAndUsernames 'c', name, user, members,
										ts: now
										did: _id

									for username in members
										member = TAGT.models.Users.findOneByUsername username
										if not member?
											continue

										extra = {}

										if username is user.username
											extra.ls = now
											extra.open = true

										TAGT.models.Subscriptions.createWithRoomAndUser room, member, extra
									
									# set creator as channel moderator.  permission limited to channel by scoping to rid
									TAGT.authz.addUserRoles(Meteor.userId(), ['owner'], room._id)

									TAGT.callbacks.run 'afterCreateChannel', user, room

									debate.rid = room._id
								else
									if name.length > TAGT.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') || name.length < TAGT.settings.get('UTF8_Long_Names_And_Introduction_MinLength')
										throw new Meteor.Error 'error-invalid-name-length', TAPi18n.__ "Invalid name name length must in #{TAGT.settings.get('UTF8_Long_Names_And_Introduction_MinLength')} , #{TAGT.settings.get('UTF8_Long_Names_And_Introduction_MaxLength')}", {  function: 'createChannel', name: name, min_length: TAGT.settings.get('UTF8_Long_Names_And_Introduction_MinLength'), max_length: TAGT.settings.get('UTF8_Long_Names_And_Introduction_MaxLength') }

									TAGT.models.Rooms.setNameById temp.rid, name
									TAGT.models.Subscriptions.updateNameByRoomId temp.rid, name
								TAGT.models.Debates.createDebate debate
								

								tag = TAGT.models.Tags.findOneByNameAndType debate.debateType, "o"
								TAGT.models.Debates.pushTag _id, {_id: tag._id, name: tag.name, t: tag.t}

								newstag = TAGT.models.Tags.findOneByNameAndType "News", "o"
								TAGT.models.Debates.pushTag _id, {_id: newstag._id, name: newstag.name}
								record._id = _id
							else
								throw new Meteor.Error 'error-duplicate-debate-name', "A debate with name '" + name + "' exists"
						else
							TAGT.models.Debates.createDebate debate
							record._id = _id
					else
						throw new Meteor.Error 'error-empty-debate-name', "A debate with name is empty"
				else
					throw new Meteor.Error 'error-notexist-debate-slug', "A debate with slug '" + slug + "' empty"
			else
				if name?
					throw new Meteor.Error 'error-init-debate', "A debate init error with name"
				else
					if save is true
						throw new Meteor.Error 'error-init-debate', "A debate init error with save"
					else
						temp = TAGT.models.Debates.find {save: false, "u._id": user._id}
						if temp.count() > 0
							record = temp.fetch()[0]
						else
							record = TAGT.models.Debates.createDebate debate
		catch error
			throw new Meteor.Error error.error, error.message, { method: 'createDebate' }


		# name = s.slugify name
		TAGT.callbacks.run 'afterCreateDebate', debate

		return record._id