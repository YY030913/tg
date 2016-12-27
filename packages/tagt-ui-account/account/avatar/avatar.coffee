Template.avatar.helpers
	imageUrl: ->
		username = this.username
		if not username? and this.userId?
			username = Meteor.users.findOne(this.userId)?.username

		if not username?
			return

		users = [].concat(username)
		
		return _.map users, (element, index, list) ->

			Session.get "avatar_random_#{element}"

			return getAvatarUrlFromUsername(element)
