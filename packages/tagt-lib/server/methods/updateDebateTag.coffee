Meteor.methods
	updateDebateTag: (_id, tag) ->
		tag.name = _.trim(tag.name)
		tag.t = "u"
		user = Meteor.user()

		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'updateDebateTag' }

		now = new Date()

		option = {
			name: 1
		}

		exist = {}
		# avoid tag name not exist
		if tag._id?
			exist = TAGT.models.Tags.findOneById tag._id
		else
			exist = TAGT.models.Tags.findOneByNameAndType tag.name, "u"

		if not exist?
			tagid = Meteor.call 'createTag', {name: tag.name, description: tag, t: "u"}
			updateTag = {_id: tagid, name: tag.name, userId: user._id, t: "u"}
		else 
			if exist.u._id == user._id
				updateTag = {_id: exist._id, name: tag.name, userId: user._id, t: "u"}
				update = TAGT.models.Tags.createOrUpdate tag
				TAGT.models.DebateSubscriptions.updateNameByTagId tag._id, tag.name
			else
				throw new Meteor.Error 'error-not-allowed', "Not allowed for current username", { method: 'updateDebateTag' }

		debate = TAGT.models.Debates.findOne {_id: _id}
		
		if debate?
			if tag._id?
				TAGT.models.Debates.pullTag _id, tag
			TAGT.models.Debates.pushTag _id, updateTag
		return true