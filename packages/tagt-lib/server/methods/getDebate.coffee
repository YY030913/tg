Meteor.methods
	getDebate: (slug) ->
		unless Meteor.userId()
			return this.ready()

		record = TAGT.models.Debates.findOneBySlug slug,
			{
				fields:
					name: 1
					u: 1
					ts: 1
					htmlBody: 1
			}
			
		return record