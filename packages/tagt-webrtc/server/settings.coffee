TAGT.settings.addGroup 'WebRTC', ->
	@add 'WebRTC_Enable_Channel', true, { type: 'boolean', group: 'WebRTC', public: true}
	@add 'WebRTC_Enable_Private', true , { type: 'boolean', group: 'WebRTC', public: true}
	@add 'WebRTC_Enable_Direct' , true , { type: 'boolean', group: 'WebRTC', public: true}
	
	#@add 'WebRTC_Servers', 'stun:stun.l.google.com:19302, stun:23.21.150.121, xiaoyu:123456@turn:numb.viagenie.ca', { type: 'string', group: 'WebRTC', public: true}
	@add 'WebRTC_Servers', 'stun:115.28.81.231', { type: 'string', group: 'WebRTC', public: true}

	@add 'Webrtc_Max_Len_Of_Left', 4, { type: 'int', group: 'WebRTC', public: true}
	@add 'Webrtc_Max_Len_Of_Right', 4, { type: 'int', group: 'WebRTC', public: true}