TAGT.Migrations.add
	version: 4
	up: ->

		TAGT.models.Messages.tryDropIndex 'rid_1'
		TAGT.models.Subscriptions.tryDropIndex 'u._id_1'


		console.log 'Rename rn to name'
		TAGT.models.Subscriptions.update({rn: {$exists: true}}, {$rename: {rn: 'name'}}, {multi: true})


		console.log 'Adding names to rooms without name'
		TAGT.models.Rooms.find({name: ''}).forEach (item) ->
			name = Random.id().toLowerCase()
			TAGT.models.Rooms.setNameById item._id, name
			TAGT.models.Subscriptions.update {rid: item._id}, {$set: {name: name}}, {multi: true}


		console.log 'Making room names unique'
		TAGT.models.Rooms.find().forEach (room) ->
			TAGT.models.Rooms.find({name: room.name, _id: {$ne: room._id}}).forEach (item) ->
				name = room.name + '-' + Random.id(2).toLowerCase()
				TAGT.models.Rooms.setNameById item._id, name
				TAGT.models.Subscriptions.update {rid: item._id}, {$set: {name: name}}, {multi: true}


		console.log 'End'
