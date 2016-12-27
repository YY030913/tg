Meteor.methods
	clearWebrtc: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'clearWebrtc' }

		option = {
			name: 1
		}

		room = TAGT.models.Rooms.findOne({_id: _id})

		if room.did?
			debate = TAGT.models.Debates.findOne {_id: room.did}
		
			if debate?
				TAGT.models.Debates.removeAllWebrtcJoined room.did

		if room?
			if TAGT.models.Rooms.findOne({_id: _id, "left._id": user._id})?
				TAGT.models.Rooms.removeLeftById _id, {_id: user._id}
				
			if TAGT.models.Rooms.findOne({_id: _id, "right._id": user._id})?
				TAGT.models.Rooms.removeRightById _id, {_id: user._id}


		debate = TAGT.models.Debates.findOne {_id: _id}
		
		if debate?
			TAGT.models.Debates.removeAllWebrtcJoined _id

		return true