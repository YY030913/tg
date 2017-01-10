Template.loginHeader.helpers
	logoUrl: ->
		siteurl = TAGT.settings.get('Site_Url')
		asset = TAGT.settings.get('Assets_logo')
		console.log asset
		if asset?
			if asset.url
				return "#{siteurl}/#{asset.url}" 
			else
				return "#{siteurl}/#{asset.defaultUrl}"
