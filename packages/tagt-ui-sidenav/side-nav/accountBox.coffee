Template.accountBox.helpers
	fixCordova: (url) ->

		console.log "fixcordova"
		url = "/images/medals/#{url}.png"
		
		if Meteor.isCordova and url?[0] is '/'
			url = Meteor.absoluteUrl().replace(/\/$/, '') + url
			
		return url

	myUserInfo: ->
		visualStatus = "online"
		username = Meteor.user()?.username
		shortCountry = Meteor.user()?.shortCountry
		medals = Meteor.user()?.medals
		switch Session.get('user_' + username + '_status')
			when "away"
				visualStatus = t("away")
			when "busy"
				visualStatus = t("busy")
			when "offline"
				visualStatus = t("invisible")
		return {
			name: Session.get('user_' + username + '_name')
			status: Session.get('user_' + username + '_status')
			visualStatus: visualStatus
			_id: Meteor.userId()
			username: username
			shortCountry: shortCountry
			medals: medals
		}

	showAdminOption: ->
		return TAGT.authz.hasAtLeastOnePermission( ['view-statistics', 'view-room-administration', 'view-user-administration', 'view-privileged-setting' ]) or TAGT.AdminBox.getOptions().length > 0

	registeredMenus: ->
		return AccountBox.getItems()

Template.accountBox.events
	'click #account': (event) ->
		menu.close()
		FlowRouter.go 'account'

	'click .thumb': (event) ->
		menu.close()
		FlowRouter.go 'account'

Template.accountBox.onRendered ->
	AccountBox.init()
