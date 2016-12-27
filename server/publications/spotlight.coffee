Meteor.methods
	spotlight: (text, usernames, type = { users: true, rooms: true }) ->
		result =
				users: []
				rooms: []

		if not this.userId?
			return result

		regex = new RegExp s.trim(s.escapeRegExp(text)), "i"

		if type.users is true and TAGT.authz.hasPermission this.userId, 'view-d-room'
			result.users = TAGT.models.Users.findByActiveUsersUsernameExcept(text, usernames, { limit: 5, fields: { username: 1, status: 1 }, sort: { username: 1 } }).fetch()

		if type.rooms is true and TAGT.authz.hasPermission this.userId, 'view-c-room'
			username = TAGT.models.Users.findOne(this.userId, {username: 1}).username
			result.rooms = TAGT.models.Rooms.findByNameAndTypeNotContainingUsername(regex, 'c', username, { limit: 5, fields: { t: 1, name: 1 }, sort: { name: 1 } }).fetch()

		return result

DDPRateLimiter.addRule
	type: 'method'
	name: 'spotlight'
	userId: (userId) ->
		return true
, 10, 10000
