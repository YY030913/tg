TAGT.tagTypes = new class
	tagTypes = {}

	### add a publish for a tag type
	@param tagType: tag type (e.g.: c (for channels), d (for direct channels))
	@param callback: function that will return the publish's data
	###
	setPublish = (tagType, callback) ->
		if tagTypes[tagType]?.publish?
			throw new Meteor.Error 'route-publish-exists', 'Publish for the given type already exists'

		unless tagTypes[tagType]?
			tagTypes[tagType] = {}

		tagTypes[tagType].publish = callback

	### run the publish for a tag type
	@param tagType: tag type (e.g.: c (for channels), d (for direct channels))
	@param identifier: identifier of the tag
	###
	runPublish = (tagType, identifier) ->
		return unless tagTypes[tagType].publish?
		return tagTypes[tagType].publish.call this, identifier

	setPublish: setPublish
	runPublish: runPublish
