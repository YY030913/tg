TAGT.models.Devices = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'devices'

		@tryEnsureIndex { 'slug': 1 }, { unique: 1, sparse: 1 }
		@tryEnsureIndex { 'name': 1 }, { unique: 1, sparse: 1 }
	#status: 0：关闭永不可见，1：所有人可见，2：私密（通过指定slug访问）

	findByDeviceid: (deviceid, options) ->
		query = 
			del: 
				$ne: true
			deviceid: deviceid
		return @find query, options

	findOneByUserid: (userid, options) ->
		query = 
			del: 
				$ne: true
			userid: userid
		return @find query, options

	# UPDATE
	unbindDevice: (userid, deviceid) ->
		query =
			userid: userid
			deviceid: deviceid

		update =
			$set:
				del: true
			unbindAt:
				new Date()

		return @update query, update

	# INSERT
	createDevice: (deviceid, userid) ->
		record = {
			ts: new Date()
			del: false
			deviceid: deviceid
			userid, userid
		}

		return @insert record
