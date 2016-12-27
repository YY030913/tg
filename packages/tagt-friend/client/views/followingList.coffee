Template.followingList.helpers
	friends: ->
		exist = []
		return _.map((_.sortBy(TAGT.models.Follow.find({"friend._id": @userId}).fetch(), "u.pinyin")), (obj) ->
			if new RegExp(/[a-z]/).test(obj.u.pinyin.substr(0, 1))
				if !exist[obj.u.pinyin.substr(0, 1)]?
					obj.friendCate = obj.u.pinyin.substr(0, 1)
			else
				if !exist["#"]?
					obj.friendCate = "#"

			return obj
		)
	notcurrentuser: (userId) ->
		return Meteor.userId() != userId

	followed: (userId) ->
		return TAGT.models.Follow.find({"friend._id": userId, "u._id": Meteor.userId()}).count()
	
		
	

Template.followingList.onCreated ->
	

Template.followingList.onRendered ->
	

Template.followingList.events
