TAGT.Migrations.add
	version: 30
	up: ->
		WebRTC_STUN_Server = TAGT.models.Settings.findOne('WebRTC_STUN_Server')?.value
		WebRTC_TURN_Server = TAGT.models.Settings.findOne('WebRTC_TURN_Server')?.value
		WebRTC_TURN_Username = TAGT.models.Settings.findOne('WebRTC_TURN_Username')?.value
		WebRTC_TURN_Password = TAGT.models.Settings.findOne('WebRTC_TURN_Password')?.value


		TAGT.models.Settings.remove({_id: 'WebRTC_STUN_Server'})
		TAGT.models.Settings.remove({_id: 'WebRTC_TURN_Server'})
		TAGT.models.Settings.remove({_id: 'WebRTC_TURN_Username'})
		TAGT.models.Settings.remove({_id: 'WebRTC_TURN_Password'})


		if WebRTC_STUN_Server is 'stun:stun.l.google.com:19302' and WebRTC_TURN_Server is 'turn:numb.viagenie.ca:3478' and WebRTC_TURN_Username is 'team@talk.get' and WebRTC_TURN_Password is 'demo'
			return

		servers = ''

		if WebRTC_STUN_Server?
			servers += WebRTC_STUN_Server

		if WebRTC_TURN_Server?
			servers += ', '
			if WebRTC_TURN_Username?
				servers += encodeURIComponent(WebRTC_TURN_Username) + ':' + encodeURIComponent(WebRTC_TURN_Password) + '@'
			servers += WebRTC_TURN_Server

		if servers isnt ''
			TAGT.models.Settings.upsert
				_id: 'WebRTC_Servers'
			,
				$set:
					value: servers
				$setOnInsert:
					createdAt: new Date
