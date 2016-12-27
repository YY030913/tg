Template.loginHeader.helpers
	logoUrl: ->
		asset = TAGT.settings.get('Assets_logo')
		if asset?
			return asset.url or asset.defaultUrl
