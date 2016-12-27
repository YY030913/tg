Template.tags.helpers
	hasPermission: ->
		return TAGT.authz.hasAtLeastOnePermission(['manage-tags', 'manage-own-tags'])

	tags: ->
		return TAGT.models.Tags.find({}, { sort: { type: 1 , name: 1} })

	dateFormated: (date) ->
		return moment(date).locale(TAPi18n.getLanguage()).format('L LT')