TAGT.Migrations.add
	version: 5
	up: ->

		console.log 'Dropping test rooms with less than 2 messages'
		TAGT.models.Rooms.find({msgs: {'$lt': 2}}).forEach (room) ->
			console.log 'Dropped: ', room.name
			TAGT.models.Rooms.removeById room._id
			TAGT.models.Messages.removeByRoomId room._id
			TAGT.models.Subscriptions.removeByRoomId room._id


		console.log 'Dropping test rooms with less than 2 user'
		TAGT.models.Rooms.find({usernames: {'$size':1}}).forEach (room) ->
			console.log 'Dropped: ', room.name
			TAGT.models.Rooms.removeById room._id
			TAGT.models.Messages.removeByRoomId room._id
			TAGT.models.Subscriptions.removeByRoomId room._id


		console.log 'Adding username to all users'
		TAGT.models.Users.find({ 'username': {'$exists':0}, 'emails': {'$exists':1} }).forEach (user) ->
			newUserName = user.emails[0].address.split("@")[0]
			if TAGT.models.Users.findOneByUsername(newUserName)
				newUserName = newUserName + Math.floor((Math.random() * 10) + 1)
				if TAGT.models.Users.findOneByUsername(newUserName)
					newUserName = newUserName + Math.floor((Math.random() * 10) + 1)
					if TAGT.models.Users.findOneByUsername(newUserName)
						newUserName = newUserName + Math.floor((Math.random() * 10) + 1);
			console.log 'Adding: username ' + newUserName + ' to all user ' + user._id;
			TAGT.models.Users.setUsername user._id, newUserName


		console.log 'Fixing _id of direct messages rooms'
		TAGT.models.Rooms.findByType('d').forEach (room) ->
			newId = ''
			id0 = TAGT.models.Users.findOneByUsername(room.usernames[0])._id
			id1 = TAGT.models.Users.findOneByUsername(room.usernames[1])._id
			ids = [id0,id1]
			newId = ids.sort().join('')
			if (newId != room._id)
				console.log 'Fixing: _id ' + room._id + ' to ' + newId
				TAGT.models.Subscriptions.update({'rid':room._id},{'$set':{'rid':newId}},{'multi':1})
				TAGT.models.Messages.update({'rid':room._id},{'$set':{'rid':newId}},{'multi':1})
				TAGT.models.Rooms.removeById(room._id)
				room._id = newId
				TAGT.models.Rooms.insert(room)
			TAGT.models.Subscriptions.update({'rid':room._id,'u._id':id0},{'$set':{'name':room.usernames[1]}})
			TAGT.models.Subscriptions.update({'rid':room._id,'u._id':id1},{'$set':{'name':room.usernames[0]}})


		console.log 'Adding u.username to all documents'
		TAGT.models.Users.find({},{'username':1}).forEach (user) ->
			console.log 'Adding: u.username ' + user.username + ' to all document'
			TAGT.models.Rooms.update({'u._id':user._id},{'$set':{'u.username':user.username}},{'multi':1})
			TAGT.models.Subscriptions.update({'u._id':user._id},{'$set':{'u.username':user.username}},{'multi':1})
			TAGT.models.Messages.update({'u._id':user._id},{'$set':{'u.username':user.username}},{'multi':1})
			TAGT.models.Messages.update({'uid':user._id},{'$set':{'u':user}},{'multi':1})
			TAGT.models.Messages.update({'by':user._id},{'$set':{'u':user}},{'multi':1})
			TAGT.models.Messages.update({'uid':{'$exists':1}},{'$unset':{'uid':1,'by':1}},{'multi':1})


		console.log 'End'
