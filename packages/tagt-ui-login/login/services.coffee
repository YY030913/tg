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
				toastr.error "wait wechat debuging"
				Meteor.loginWithWechatCordova {}, (error) ->
					overlay.hide();
					if error
						if error.reason
							toastr.error error.reason
						else
							toastr.error error.message
						return
				###
				Wechat.isInstalled ->
					toastr.error "isInstalled"
					toastr.error JSON.stringify(arguments)
				, ->
					toastr.error "isInstalled2"
					toastr.error JSON.stringify(arguments)
				scope = "snsapi_userinfo"
				state = "_" + (+new Date());
				
				Wechat.share
					text: "This is just a plain string",
					scene: Wechat.Scene.TIMELINE
					, ->
						toastr.error "share", JSON.stringify(arguments)
						console.log "share", JSON.stringify(arguments)
					, ->
						toastr.error "share2", JSON.stringify(arguments)
						console.log "share2", JSON.stringify(arguments)
				
				Wechat.auth scope, state, ->
					toastr.error "auth"
					toastr.error JSON.stringify(arguments)
				, ->
					toastr.error "auth2"
					toastr.error JSON.stringify(arguments)
					alert("Failed: " + reason);

				Wechat.share
					message: {
						title: "Hi, there",
						description: "This is description.",
						thumb: "www/img/thumbnail.png",
						mediaTagName: "TEST-TAG-001",
						messageExt: "这是第三方带的测试字段",
						messageAction: "<action>dotalist</action>",
						media: "YOUR_MEDIA_OBJECT_HERE"
					},
					scene: Wechat.Scene.TIMELINE
				, ->
					console.log("Success");
				, (reason) ->
					console.log("Failed: " + reason);

				params = 
					partnerid: '10000100',
					prepayid: 'wx201411101639507cbf6ffd8b0779950874',
					noncestr: '1add1a30ac87aa2db72f57a2375d8fec',
					timestamp: '1439531364',
					sign: '0CB01533B8C1EF103065174F50BCA001'


				Wechat.sendPaymentRequest params
				, ->
					console.log("Success");
				, (reason) ->
					console.log("Failed: " + reason);
				###
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