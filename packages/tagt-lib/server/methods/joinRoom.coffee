Meteor.methods
	joinRoom: (rid, code) ->

		check rid, String
		# check code, Match.Maybe(String)

		if not Meteor.userId()
			throw new Meteor.Error 'error-invalid-user', 'Invalid user', { method: 'joinRoom' }

		room = TAGT.models.Rooms.findOneById rid

		if not room?
			throw new Meteor.Error 'error-invalid-room', 'Invalid room', { method: 'joinRoom' }

		if room.t isnt 'c' or TAGT.authz.hasPermission(Meteor.userId(), 'view-c-room') isnt true
			throw new Meteor.Error 'error-not-allowed', 'Not allowed', { method: 'joinRoom' }

		if room.joinCodeRequired is true and code isnt room.joinCode
			throw new Meteor.Error 'error-code-invalid', 'Invalid Code', { method: 'joinRoom' }

		TAGT.addUserToRoom(rid, Meteor.user())

		if room.did
			exist = TAGT.models.Users.findOne {_id: Meteor.userId(), "debates._id": room.did, "save": true},
				fields:
					debates: 1

			if !exist?
				activity = TAGT.Activity.utils.add(room.name, "", 'join_debate', 'Join_Debae', "/debate/#{room.did}")
				
				activity.userId = Meteor.userId()
				TAGT.models.Activity.createActivity(activity)

				###
				score = TAGT.Score.utils.add("/debate/#{room.did}", 'join_debate', 'Join_Debae')
				score.userId = Meteor.userId()
				score.score = TAGT.Score.utils.debateJoinScore
				TAGT.models.Score.create(score)
				###

				TAGT.models.Users.addDebate Meteor.userId(), {_id: room.did}
		else
			exist = TAGT.models.Users.findOne {_id: Meteor.userId(), "debates._id": room.did, "save": true},
				fields:
					debates: 1

			if !exist?
				activity = TAGT.Activity.utils.add(room.name, "", 'join_room', 'Join_Debae', "/room/#{room.did}")
				
				activity.userId = Meteor.userId()
				TAGT.models.Activity.createActivity(activity)

				###
				score = TAGT.Score.utils.add("/room/#{room.did}", 'create_room', 'Create_Debae')
				score.userId = Meteor.userId()
				score.score = TAGT.Score.utils.roomJoinScore
				TAGT.models.Score.create(score)
				###