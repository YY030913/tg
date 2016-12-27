TAGT.Migrations.add
	version: 42
	up: ->
		files = TAGT.__migration_assets_files = new Mongo.Collection('assets.files')
		chunks = TAGT.__migration_assets_chunks = new Mongo.Collection('assets.chunks')
		list = {
			'favicon.ico': 'favicon_ico'
			'favicon.svg': 'favicon'
			'favicon_64.png': 'favicon_64'
			'favicon_96.png': 'favicon_96'
			'favicon_128.png': 'favicon_128'
			'favicon_192.png': 'favicon_192'
			'favicon_256.png': 'favicon_256'
		}

		for from, to of list
			if not files.findOne({_id: to})?
				oldFile = files.findOne({_id: from})
				if oldFile?
					extension = TAGT.Assets.mime.extension(oldFile.contentType)
					TAGT.settings.removeById "Assets_#{from}"
					TAGT.settings.updateById "Assets_#{to}", {
						url: "/assets/#{to}.#{extension}"
						defaultUrl: TAGT.Assets.assets[to].defaultUrl
					}
					oldFile._id = to
					oldFile.filename = to
					files.insert(oldFile)
					files.remove({_id: from})
					chunks.update({files_id: from}, {$set: {files_id: to}}, {multi: true})

