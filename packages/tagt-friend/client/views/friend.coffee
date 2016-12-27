Template.friend.helpers
	friends: ->
		exist = []
		return _.map((_.sortBy(TAGT.models.Follow.find({"u._id": Meteor.userId()}).fetch(), "friend.pinyin")), (obj) ->
			if new RegExp(/[a-z]/).test(obj.friend.pinyin.substr(0, 1))
				if !exist[obj.friend.pinyin.substr(0, 1)]?
					obj.friendCate = obj.friend.pinyin.substr(0, 1)
			else
				if !exist["#"]?
					obj.friendCate = "#"

			return obj
		)
	isSubsc: ->
		return FlowRouter.subsReady('follow')
	

Template.friend.onCreated ->
	

Template.friend.onRendered ->
	

Template.friend.events
