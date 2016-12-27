FlowRouter.goToRoomById = (roomId) ->
	subscription = ChatSubscription.findOne({rid: roomId})
	if subscription?
		FlowRouter.go TAGT.roomTypes.getRouteLink subscription.t, subscription
