TAGT.models.Ad = new class extends TAGT.models._Base
	constructor: ->
		@_initModel 'ad'

	# FIND
	findAllOpen: (options) ->
		query =
			hidden:
				$ne: true
			del: {
				$ne: true
			}

		return @find query, options


	# INSERT
	createAd: (ad, option) ->
		record = {
			u: ad.u
			ts: new Date()
			hidden: false
			del: false
			name: ad.name
			url: ad.url
			cover: ad.cover
		}
		record = _.extend record, option

		return @insert record

	# HIDDEN
	hideAd: (_id) ->
		query = {
			_id: _id
		}

		update =
			$set:
				hidden: true

		return @update query, update

	# DEL
	delAd: (_id) ->
		query = {
			_id: _id
		}

		update =
			$set:
				del: true

		return @update query, update