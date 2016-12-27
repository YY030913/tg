TAGT.settings.onload 'CDN_PREFIX', (key, value, initialLoad) ->
	if _.isString value
		WebAppInternals?.setBundledJsCssPrefix value

Meteor.startup ->
	value = TAGT.settings.get 'CDN_PREFIX'
	if _.isString value
		WebAppInternals?.setBundledJsCssPrefix value
