Meteor.methods
	removeDebateTag: (_id, tid, name) ->
		
		user = Meteor.user()

		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'updateDebateTag' }

		now = new Date()

		option = {
			name: 1
		}

		exist = {}

		console.log tid

		if tid?
			exist = TAGT.models.Tags.findOneById tid
		else
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'updateDebateTag' }

		if not exist?
			throw new Meteor.Error 'error-not-allowed', "Not allowed", { method: 'updateDebateTag' }

		debate = TAGT.models.Debates.findOne {_id: _id, "tags._id": tid}
		
		if debate?
			
			if debate.u._id == user._id
				TAGT.models.Debates.pullTag _id, {_id: tid, name: name, t: "u"}
			else
				throw new Meteor.Error 'error-not-allowed', "Not allowed for current username", { method: 'updateDebateTag' }
		else
			throw new Meteor.Error 'error-not-allowed', "Not allowed for current username", { method: 'updateDebateTag' }
		return true