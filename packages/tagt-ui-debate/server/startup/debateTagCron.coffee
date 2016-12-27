# Config and Start SyncedCron
logger = new Logger 'SyncedCron'

SyncedCron.config
	logger: (opts) ->
		logger[opts.level].call(logger, opts.message)
	collectionName: 'tagt_Debate_Tag_Cron_history'

updateDebateTag = ->
	now = new Date
	hourago = new Date(now - 3600000)
	userCount = TAGT.models.Users.find().count()
	debates = TAGT.models.Debates.findList({
		save: true
	}, {field: {_id: 1, ts: 1, "read.ts": 1, "share.ts":1, "favorite.favoriteAt":1, "favorite.enable": 1}}).fetch()
	for debate in debates
		updateTags = []
		pullTags = []

		newstag = TAGT.models.Tags.findOneByNameAndType "News", "o"

		TAGT.models.Debates.pullTag debate._id, {_id: newstag._id, name: newstag.name, t: newstag.t}
		if (now.getDate() - (new Date(debate.ts)).getDate() < 7)
			TAGT.models.Debates.pushTag debate._id, {_id: newstag._id, name: newstag.name, t: newstag.t}

		readlen = debate.read.length
		readcount = 0
		while readlen > 0
			if debate.read[readlen-1].ts > hourago 
				readcount++
				readlen--
			else
				readlen = 0

		favoritelen = debate.favorite.length
		favoritecount = 0
		while favoritelen > 0 
			if debate.favorite[readlen-1].favoriteAt > hourago and favoriteitem.enable
				favoritecount++
				favoritelen--
			else
				favoritelen = 0

		sharelen = debate.share.length
		sharecount = 0
		while sharelen > 0 
			if debate.share[readlen-1].ts > hourago 
				sharecount++
				sharelen--
			else
				sharelen = 0


		hottag = TAGT.models.Tags.findOneByNameAndType "Hot", "o"
		TAGT.models.Debates.pullTag debate._id, {_id: hottag._id, name: hottag.name, t: hottag.t}
		if (readcount / userCount) * TAGT.Debate.readWeight + (sharecount / userCount) * TAGT.Debate.shareWeight + (favoritecount / userCount) * TAGT.Debate.favoriteWeight > 0.5
			TAGT.models.Debates.pushTag debate._id,  {_id: hottag._id, name: hottag.name, t: hottag.t}

	true


Meteor.startup ->
	Meteor.defer ->
		updateDebateTag()

		# Generate and save statistics every hour
		SyncedCron.add
			name: 'update Debate Tag Cron',
			schedule: (parser) -># parser is a later.parse object
				return parser.text 'every 1 hour'
			job: updateDebateTag

		SyncedCron.start()