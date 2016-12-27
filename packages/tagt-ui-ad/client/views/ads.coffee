Template.ads.helpers
	hasPermission: ->
		return TAGT.authz.hasAtLeastOnePermission(['manage-ads', 'manage-own-ads'])

	ads: ->
		return TAGT.models.Ads.find({}, { sort: { ts: 1, type: 1 , name: 1} })

	dateFormated: (date) ->
		return moment(date).locale(TAPi18n.getLanguage()).format('L LT')