Template.followerList.helpers
	friends: ->
		exist = []
		return  _.map((_.sortBy(TAGT.models.Follow.find({"u._id": @userId}).fetch(), "friend.pinyin")), (obj) ->
			if new RegExp(/[a-z]/).test(obj.friend.pinyin.substr(0, 1))
				if !exist[obj.friend.pinyin.substr(0, 1)]?
					obj.friendCate = obj.friend.pinyin.substr(0, 1)
			else
				if !exist["#"]?
					obj.friendCate = "#"

			return obj
		)
	notcurrentuser: (userId) ->
		Meteor.userId() == userId
		return true

	followed: (userId) ->
		return TAGT.models.Follow.find({"u._id": userId, "friend._id": Meteor.userId()}).count()
	
		
	

Template.followerList.onCreated ->
	

Template.followerList.onRendered ->
	

Template.followerList.events
