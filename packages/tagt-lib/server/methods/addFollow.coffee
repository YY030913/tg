Meteor.methods
	addFollow: (_id) ->
		user = Meteor.user()
		if not user._id
			throw new Meteor.Error 'error-invalid-user', "Invalid user", { method: 'addFollow' }

		if TAGT.authz.hasPermission(user._id, 'update-follow') isnt true
			throw new Meteor.Error 'update-follow', "Not allowed", { method: 'addFollow' }

		now = new Date()

		option = {
			name: 1
			pinyin: 1
		}

		friend = TAGT.models.Users.findOneById _id, option

		if not friend
			throw new Meteor.Error 'update-follow', "user not exist", { method: 'addFollow' }


		data = {
			u:
				_id: user._id
				name: user.username
				pinyin: user.pinyin
			friend:
				_id: _id
				name: friend.username
				pinyin: friend.pinyin
		}

		follow = TAGT.models.Friend.findByOne user._id, _id
		
		if not follow
			follow = TAGT.models.Friend.findByOneDel user._id, _id
			if not follow
				TAGT.models.Friend.createFriend data
			TAGT.models.Friend.refollowFriend user._id, _id

		Member = []
		Member.push(_id)

		TAGT.models.FriendsSubscriptions.incUnreadForUserIds Member

		activity = TAGT.Activity.utils.add(friend.name, "", 'add_follow', 'Add_Follow', "/user/profile/#{friend._id}")
		activity.userId = Meteor.userId()
		TAGT.models.Activity.createActivity(activity)

		# score = TAGT.Score.utils.add("/user/profile/#{friend._id}", 'add_follow', 'Add_Follow')
		# TAGT.models.Score.update(Meteor.userId(), score, TAGT.Score.utils.addFollow)

		TAGT.callbacks.run 'afterAddFollow', data
		return true