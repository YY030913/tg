TAGT.models.Searchs = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'searchs'

		@tryEnsureIndex { 'name': 1, 'u._id': 1}, { unique: 1 }

	# FIND
	findOneByUserAndName: (uid, name, options) ->
		query =
			name: name
			"u._id": uid
			del: {
				$ne: true
			}
		return @findOne query, options

	findHot: (options) ->
		query =
			t: "hot"
			del: {
				$ne: true
			}

		return @find query, options


	findByUser: (userId, options) ->

		#collectionObj = this.model.rawCollection();
		#findAndModify = Meteor.wrapAsync(collectionObj.findAndModify, collectionObj);

		query =
			"u._id": userId
			del: {
				$ne: true
			}

		if options.end?
			query = _.extend query,
				ts:
					$lt: timestamp
					
		options = _.extend options, 
			sort: {
				ts: -1
			}

		update = {
			$inc: {
				findCount: 1
			}
		}
		#searchs = findAndModify(query, sort, update)

		searchs = @find query, options
		if searchs 
			return searchs
		else 
			return null

	# INSERT
	incSearchCount: (uid, name) ->
		query =
			name: name
			"u._id": uid
			del: {
				$ne: true
			}

		record = {
			$inc: {
				findCount: 1
			}
		}

		return @update query, record

	createSearch: (option) ->
		option.u.ts = new Date
		record = {
			del: false
			ts: new Date
			name: option.name
			u: option.u
			findCount: 1
		}

		return @insert record


	# update

	delSearch: (name) ->
		query =
			name: name
			del: {
				$ne: true
			}

		record = {
			$set:
				del: true
			$addToSet:
				delete: 
					ts: new  Date()
		}

		return @update query, record