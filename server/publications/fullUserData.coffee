Meteor.publish 'fullUserData', (filter, limit) ->
	unless @userId
		return @ready()

	fields =
		name: 1
		username: 1
		status: 1
		utcOffset: 1
		type: 1
		active: 1

	if TAGT.authz.hasPermission( @userId, 'view-full-other-user-info') is true
		fields = _.extend fields,
			emails: 1
			phone: 1
			statusConnection: 1
			createdAt: 1
			lastLogin: 1
			services: 1
			requirePasswordChange: 1
			requirePasswordChangeReason: 1
			roles: 1
	else
		limit = 1

	filter = s.trim filter

	if not filter and limit is 1
		return @ready()

	options =
		fields: fields
		limit: limit
		sort: { username: 1 }

	if filter
		if limit is 1
			return TAGT.models.Users.findByUsername filter, options
		else
			filterReg = new RegExp s.escapeRegExp(filter), "i"
			return TAGT.models.Users.findByUsernameNameOrEmailAddress filterReg, options

	return TAGT.models.Users.find {}, options
