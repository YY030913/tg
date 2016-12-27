Template.home.helpers
	title: ->
		return TAGT.settings.get 'Layout_Home_Title'
	body: ->
		return TAGT.settings.get 'Layout_Home_Body'
