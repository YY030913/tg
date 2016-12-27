TAGT.models.Tags.findOpenForUser = (type, userId) ->
	if userId?
		user = Meteor.users.findOne({_id: userId})
		if user?
			roles = [].concat Meteor.users.findOne({_id: userId}).roles
			query =
				t: type
				showOnSelectType: 
					$in: roles

			return @find query
