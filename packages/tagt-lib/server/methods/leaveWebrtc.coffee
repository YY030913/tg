Meteor.methods
	leaveWebrtc: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'leaveWebrtc' }

		option = {
			name: 1
		}

		room = TAGT.models.Rooms.findOne({_id: _id})

		if room.did?
			debate = TAGT.models.Debates.findOne {_id: room.did}
		
			if debate?
				joined = TAGT.models.Debates.findOne({_id: room.did, "webrtcJoined._id": user._id})

				if joined?
					TAGT.models.Debates.pullWebrtcJoined room.did, {_id: user._id}

		if room?
			if TAGT.models.Rooms.findOne({_id: _id, "left._id": user._id})?
				TAGT.models.Rooms.removeLeftById _id, {_id: user._id}
				
			if TAGT.models.Rooms.findOne({_id: _id, "right._id": user._id})?
				TAGT.models.Rooms.removeRightById _id, {_id: user._id}

		return true