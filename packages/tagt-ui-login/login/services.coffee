Meteor.startup ->
	ServiceConfiguration.configurations.find({custom: true}).observe
		added: (record) ->
			new CustomOAuth record.service,
				serverURL: record.serverURL
				authorizePath: record.authorizePath
				scope: record.scope

Template.loginServices.helpers

	loginService: ->
		services = []

		authServices = ServiceConfiguration.configurations.find({}, { sort: {service: 1} }).fetch()

		authServices.forEach (service) ->
			switch service.service
				when 'meteor-developer'
					serviceName = 'Meteor'
					icon = 'meteor'
				when 'github'
					serviceName = 'GitHub'
					icon = 'github-circled'
				when 'gitlab'
					serviceName = 'GitLab'
					icon = service.service
				when 'wordpress'
					serviceName = 'WordPress'
					icon = service.service
				when 'weibo'
					serviceName = 'WeiBo'
					icon = 'weibo'
				when 'wechat'
					serviceName = 'WeChat'
					icon = 'wechat'
				else
					serviceName = _.capitalize service.service
					icon = service.service

			services.push
				service: service
				displayName: serviceName
				icon: icon

		return services

Template.loginServices.events
	'click .external-login': (e, t)->
		return unless this.service?.service?

		loadingIcon = $(e.currentTarget).find('.loading-icon')
		serviceIcon = $(e.currentTarget).find('.service-icon')

		loadingIcon.removeClass 'hidden'
		serviceIcon.addClass 'hidden'

		# login with native facebook app

		if Meteor.isCordova
			opts = {
				lines: 13, 
				length: 11,
				width: 5, 
				radius: 17,
				corners: 1,
				rotate: 0, 
				color: '#FFF',
				speed: 1, 
				trail: 60, 
				shadow: false,
				hwaccel: false, 
				className: 'spinner',
				zIndex: 2e9,
				top: 'auto',
				left: 'auto'
			};
			target = document.createElement("div");
			document.body.appendChild(target);
			spinner = new Spinner(opts).spin(target);
			overlay = window.iosOverlay({
				text: "Loading",
				spinner: spinner
			});
			if this.service.service is 'facebook'
				Meteor.loginWithFacebookCordova {}, (error) ->
					overlay.hide();
					if error
						if error.reason
							toastr.error error.reason
						else
							toastr.error error.message
						return

			else if this.service.service is 'weibo'
				Meteor.loginWithWeiboCordova {}, (error) ->
					overlay.hide();
					if error
						if error.reason
							toastr.error error.reason
						else
							toastr.error error.message
						return
				
			else if this.service.service is 'google'
				Meteor.loginWithGoogleCordova {}, (error) ->
					overlay.hide();
					if error
						if error.reason
							toastr.error error.reason
						else
							toastr.error error.message
						return
				
			else if this.service.service is 'wechat'
				Meteor.loginWithWechatCordova {}, (error) ->
					overlay.hide();
					if error
						if error.reason
							toastr.error error.reason
						else
							toastr.error error.message
						return
		else
			loginWithService = "loginWith" + (if this.service.service is 'meteor-developer' then 'MeteorDeveloperAccount' else _.capitalize(this.service.service))
			serviceConfig = this.service.clientConfig or {}
			
			Meteor[loginWithService] serviceConfig, (error) ->
				loadingIcon.addClass 'hidden'
				serviceIcon.removeClass 'hidden'
				if error
					toastr.error JSON.stringify(error)
					if error.reason
						toastr.error error.reason
					else
						toastr.error error.message
					return
				else
					console.log "login"
				# ran = ranaly.createClient('3003');
				# rUsers = new ran.Amount('Users');
				# rUsers.incr();